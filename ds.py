from pyethereum import tester as t
from pyethereum import utils as u
from ethertdd import EvmContract
import subprocess
import json
import yaml
import sys

abi, binary = None, None
suite = {}

def get_paths(path, build=None):
    if build == None:
        build = yaml.load(open(path + "/build.yaml"))
    paths = []
    for k, v in build.iteritems():
        if v == True:
            paths.append(path + k)
        elif v != False: # not a bool
            subpaths = get_paths(path + k + "/", v)
            paths.extend(subpaths)
    return paths

# Tries to compile all sources
# Returns an EVM library ("pack").
def compile_sources(paths):
    cmd = ['solc']
    cmd.extend(['--combined-json', 'json-abi,binary,sol-abi'])
    cmd.extend(paths)
    print cmd
    p = subprocess.check_output(cmd, cwd=builddir+"/..")
    print p
    pack = json.loads(p)["contracts"]
    return pack

def run_tests(pack):
    for typename, info in pack.iteritems():
        if typename == "Test":
            continue
        if info["binary"] == "":
            #print "Skipping abstract class", typename
            continue
        abi = info["json-abi"]
        jabi = json.loads(abi)
        is_test = False
        for item in jabi:
            if "name" in item.keys() and item["name"] == "IS_TEST":
                is_test = True
        if not is_test:
            continue

        print "Testing", typename
        binary = info["binary"].decode('hex')
        try:
            tmp = EvmContract(abi, binary, typename, [], gas=3000000) 
        except Exception, e:
        #    print typename, info
            raise e
        for func in dir(tmp):
            if func.startswith("test"):
                print "  " + func
                contract = EvmContract(abi, binary, typename, [], gas=3000000) 
                if hasattr(contract, "setUp"):
                    contract.setUp()
                getattr(contract, func)()
                if contract.failed():
                    print "    Fail!"




if '__main__' == __name__:
    if len(sys.argv) < 2:
        print "need command ('ds test')"
        sys.exit(1)

    if sys.argv[1] == "test":
        builddir = "contracts"
        if len(sys.argv) > 2:
            builddir = sys.argv[2]
        buildpath = builddir + "/build.yaml"

        paths = get_paths(builddir+"/")
        pack = compile_sources(paths)
        run_tests(pack)
