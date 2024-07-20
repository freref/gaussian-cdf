// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {NormalDistribution} from "../src/GaussianCDF.sol";
import {LibString} from "solady/utils/LibString.sol";

contract GaussianCDFHelper is Test {
    int256[4][] testCases;

    function setUp() public {
        vm.pauseGasMetering();
        string memory inputs = vm.readFile("./test_cases.txt");
        string[] memory lines = LibString.split(inputs, "\n");

        testCases = new int256[4][](lines.length - 1);

        for (uint256 i = 0; i < lines.length - 1; i++) {
            string[] memory line = LibString.split(lines[i], ",");
            testCases[i] =
                [stringToInt256(line[0]), stringToInt256(line[1]), stringToInt256(line[2]), stringToInt256(line[3])];
        }
    }

    function stringToInt256(string memory s) public pure returns (int256 result) {
        bytes memory stringBytes = bytes(s);
        bool negative = false;
        uint256 start = 0;

        if (stringBytes[0] == '-') {
            negative = true;
            start = 1;
        }

        for (uint256 i = start; i < stringBytes.length; i++) {
            if (uint8(stringBytes[i]) >= 48 && uint8(stringBytes[i]) <= 57) {
                result = result * 10 + int8(uint8(stringBytes[i]) - 48);
            }
        }

        if (negative) {
            result = -result;
        }
    }
}