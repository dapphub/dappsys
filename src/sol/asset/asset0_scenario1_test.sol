import 'asset/asset0.sol';
import 'auth/basic_authority.sol';
import 'data/balance_db.sol';

import 'dapple/test.sol';




contract DSAsset0_Scenario is Test {
	function setUp() {
		var mkr_db = new DSBalanceDB();
		var ens_db = new DSBalanceDB();
		var dai_db = new DSBalanceDB();

		mkr_db.add_balance(me, 10**(6+18));
		ens_db.add_balance(me, 10**(6+18));

		var auth = new DSBasicAuthority();
	
		var MKR = new DSAsset0Impl( mkr_db );
		var ENS = new DSAsset0Impl( ens_db );
		var DAI = new DSAsset0Impl( dai_db );

		auth.set_can_call( me, address(MKR), 0x0, true);
		auth.set_can_call( me, address(ENS), 0x0, true);
		auth.set_can_call( me, address(DAI), 0x0, true);
		auth.set_can_call( me, address(dai_db), 0x0, true);
		auth.set_can_call( address(DAI), address(dai_db), 0x0, true);

		auth._ds_update_authority( DSAuthority(me), 0 );

		MKR._ds_update_authority( auth, 1 );
		ENS._ds_update_authority( auth, 1 );
		DAI._ds_update_authority( auth, 1 );
		dai_db._ds_update_authority( auth, 1 );
		mkr_db._ds_update_authority( MKR, 0 );
		ens_db._ds_update_authority( ENS, 0 );

		var (bal, ok) = MKR.get_balance(address(me));
		assertTrue(bal == 10**(24));
		(bal, ok) = DAI.get_balance(address(me));
		assertTrue(bal == 0, "wrong initial dai balance");
		dai_db.add_balance(me, 1000);
		(bal, ok) = DAI.get_balance(me);
		assertTrue(bal == 1000, "couldn't add balance");

		DAI.transfer(address(0x0), 500);
		(bal, ok) = DAI.get_balance(me);
		assertTrue(bal == 500, "couldn't use normal transfer");
	}
	function testScenario() {
	}
}
