// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "ds-test/test.sol";
import "../src/UniswapV2.sol";

interface Vm {
    function store(
        address,
        bytes32,
        bytes32
    ) external;
}

contract UniswapV2Test is DSTest {
    Vm vm = Vm(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);

    UniswapV2 uniswap;

    address constant wethAddress = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    function setUp() public {
        uniswap = new UniswapV2();
    }

    function testFlashLoan() public {
        uint256 amount = 1 ether;
        // Premium 0.3009027%
        uint256 premium = (amount * 1000) / uint256(997) + 1 - amount;

        vm.store(
            wethAddress,
            keccak256(abi.encode(address(uniswap), uint256(3))),
            bytes32(premium * 10)
        );

        for (uint256 i; i < 10; i++) {
            uniswap.go(amount);
        }
    }
}
