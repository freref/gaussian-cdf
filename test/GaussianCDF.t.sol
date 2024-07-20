// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {NormalDistribution} from "../src/GaussianCDF.sol";
import {GaussianCDFHelper} from "./GaussianCDFHelper.sol";

contract GaussianTest is GaussianCDFHelper {
    function abs(int x) private pure returns (int) {
        return x >= 0 ? x : -x;
    }

    function test_gaussianCorrectnessCDF() public view {
        int256 max = 0;
        int256 average = 0;

        for (uint256 i = 0; i < testCases.length; i++) {
            int256 x = testCases[i][0];
            int256 mu = testCases[i][1];
            int256 sigma = testCases[i][2];
            int256 expectedResult = testCases[i][3];
            int256 result = NormalDistribution.cdf(x, mu, sigma);

            int256 diff = abs(abs(result) - abs(expectedResult));

            average += diff;
            if (diff > max) {
                max = diff;
            }

            assertLe(diff, 1e18);
        }
        console.log("1e8 Fixed Point Error Threshold: \t 10000000000");
        console.log("Max Error: \t \t \t \t", max);
        console.log(
            "Average Error: \t \t \t",
            average / int256(testCases.length)
        );
    }
}
