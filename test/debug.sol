contract Debug {
    event logs(bytes val);

    // Generate log_* and log_named* functions
    /*[[[cog
    import cog
    types = ['bool', 'uint', 'int', 'address', 'bytes']
    for i in range(32):
        types.append('bytes'+str(i+1))

    for type in types:
        cog.outl("event log_" + type + "(" + type + " val);")
        cog.outl("event log_named_" + type + "(bytes32 key, " + type + " val);")
    ]]]*/
    //[[[end]]]
}
