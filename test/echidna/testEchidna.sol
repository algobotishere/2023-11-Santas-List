// SPDX-License-Identifier: MIT

pragma solidity 0.8.23;

import { SantasList } from "../../src/SantasList.sol";
import { SantaToken } from "../../src/SantaToken.sol";

// contract testEchidna is SantasList {
//   constructor() {}

//   function echidna_test() public returns (bool) {
//     return s_theListCheckedOnce[msg.sender] == Status.EXTRA_NICE;
//   }
// }

contract EchidnaTest {
  SantasList santasList;
  SantaToken santaToken;

  constructor() {
    santasList = new SantasList();
  }

  function echidna_only_santa_can_check() public returns (bool) {
    (bool success, ) = address(santasList).call(
      abi.encodeWithSignature("checkList(address,uint8)", address(1), uint8(0))
    );
    return (!success);
  }

  //   function echidna_add_nice_list() public returns (bool) {
  //     santasList.checkList(address(1), SantasList.Status.NICE);
  //     santasList.checkTwice(address(1), SantasList.Status.NICE);
  //     return (santasList.getNaughtyOrNiceOnce(address(1)) != SantasList.Status.NICE ||
  //       santasList.getNaughtyOrNiceTwice(address(1)) != SantasList.Status.NICE);
  //   }

  //   function echidna_only_nice_can_claim() public {
  //     santasList.checkList(address(1), SantasList.Status.NICE);
  //     santasList.checkTwice(address(1), SantasList.Status.NICE);

  //     try santasList.collectPresent() {
  //       assert(santasList.balanceOf(address(1)) > 0);
  //     } catch {
  //       assert(false);
  //     }
  //   }

  //   function echidna_extra_nice_gets_extra() public {
  //     address addr = address(2);

  //     santasList.checkList(addr, SantasList.Status.EXTRA_NICE);
  //     santasList.checkTwice(addr, SantasList.Status.EXTRA_NICE);

  //     try santasList.collectPresent() {
  //       assert(santasList.balanceOf(addr) > 0);
  //       assert(SantaToken(santasList.getSantaToken()).balanceOf(addr) > 0);
  //     } catch {
  //       assert(false);
  //     }
  //   }
}
