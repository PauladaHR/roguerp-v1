 -----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPC = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
hiro = {}
Tunnel.bindInterface("vrp_race",hiro)
vCLIENT = Tunnel.getInterface("vrp_race")
-----------------------------------------------------------------------------------------------------------------------------------------
-- TABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local preRaceStart = {}
local raceStarter = {}
local inprogressRace = {}
local preLeaderboard = {}
local globalCooldown = {}
local playersNames = {}
local myNames = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- RACES
-----------------------------------------------------------------------------------------------------------------------------------------
local races = {
	[1] = {
		["initialCoord"] = { -1040.77,-404.58,32.66 },
		["time"] = 400,
		["stress"] = 5,
        ["payment"] = { 1000,1340 },
        ["maxPlayers"] = 10,
        ["raceCooldown"] = 900,
		["coordsRace"] = {
			[1] = { -1127.57,-404.46,35.9 },
			[2] = { -1334.55,-521.56,31.67 },
			[3] = { -1334.55,-521.56,31.67 },
			[4] = { -1616.72,-559.18,33.48 },
			[5] = { -1597.62,-479.15,35.75 },
			[6] = { -1622.75,-420.85,39.58 },
			[7] = { -1586.87,-315.52,48.26 },
			[8] = { -1587.01,-145.95,54.93 },
			[9] = { -1674.16,-14.32,62.03 },
			[10] = { -1893.21,176.56,81.34 },
			[11] = { -1963.85,359.9,90.72 },
			[12] = { -1959.39,588.38,117.71 },
			[13] = { -1728.29,832.22,143.19 },
			[14] = { -1617.79,983.86,152.98 },
			[15] = { -1453.53,833.16,183.52 },
			[16] = { -1289.1,813.01,188.87 },
			[17] = { -1152.21,996.71,202.96 },
			[18] = { -1027.69,1176.47,216.83 },
			[19] = { -891.09,1022.98,224.82 },
			[20] = { -685.26,990.93,237.79 },
			[21] = { -431.29,901.61,236.71 },
			[22] = { -317.24,1013.49,232.97 },
			[23] = { -136.82,1047.51,229.09 },
			[24] = { 57.69,1025.54,216.91 },
			[25] = { 349.54,999.2,209.87 },
			[26] = { 474.05,909.81,197.6 },
			[27] = { 511.77,984.91,208.54 },
            [28] = { 501.95,1102.42,230.11 },
            [29] = { 415.12,1185.68,245.95 },
            [30] = { 479.71,1308.06,278.66 },
            [31] = { 640.2,1388.25,322.03 },
            [32] = { 828.19,1275.98,359.75 },
		}
	},
    [2] = {
		["initialCoord"] = { -694.0,-757.0,29.1 },
		["time"] = 420,
		["stress"] = 5,
        ["payment"] = { 1000,1340 },
        ["maxPlayers"] = 8,
        ["raceCooldown"] = 900,
		["coordsRace"] = {
            [1] = { -740.34,-730.61,27.95 },
            [2] = { -774.83,-652.86,29.52 },
            [3] = { -895.62,-653.36,27.59 },
            [4] = { -1111.19,-780.34,18.65 },
            [5] = { -1203.18,-856.07,13.46 },
            [6] = { -1293.49,-881.65,11.23 },
            [7] = { -1380.19,-792.48,19.2 },
            [8] = { -1567.96,-644.69,29.29 },
            [9] = { -1731.15,-557.47,37.04 },
            [10] = { -2048.43,-418.91,11.07 },
            [11] = { -1705.57,-695.17,11.24 },
            [12] = { -1368.0,-760.88,10.79 },
            [13] = { -1111.11,-645.25,12.84 },
            [14] = { -696.65,-530.82,24.91 },
            [15] = { -187.69,-525.72,27.37 },
            [16] = { 275.08,-520.93,33.76 },
            [17] = { 895.78,-753.48,40.49 },
            [18] = { 1005.33,-977.23,30.39 },
            [19] = { 1031.0,-1107.07,38.04 },
            [20] = { 1223.27,-1191.02,46.65 },
            [21] = { 1476.78,-1055.58,55.48 },
            [22] = { 1935.7,-741.94,86.7 },
            [23] = { 2173.36,-549.27,94.03 },
            [24] = { 2419.8,-239.02,85.3 },
            [25] = { 2576.51,187.17,98.53 },
            [26] = { 2562.62,492.63,108.19 },
		}
	},
    [3] = {
		["initialCoord"] = { 634.69,-415.72,24.71 },
		["time"] = 410,
		["stress"] = 5,
        ["payment"] = { 1000,1340 },
        ["maxPlayers"] = 8,
        ["raceCooldown"] = 600,
		["coordsRace"] = {
            [1] = { 705.52,-371.81,41.67 },
            [2] = { 440.95,-355.05,47.01 },
            [3] = { 289.98,-491.3,43.01 },
            [4] = { 171.53,-722.33,32.76 },
            [5] = { 67.81,-710.82,31.31 },
            [6] = { -1.76,-862.33,30.12 },
            [7] = { -110.37,-916.09,29.05 },
            [8] = { -228.51,-978.0,28.99 },
            [9] = { -315.15,-1132.0,23.93 },
            [10] = { -572.18,-956.37,23.24 },
            [11] = { -695.23,-1062.14,14.36 },
            [12] = { -814.2,-1135.99,9.3 },
            [13] = { -1277.69,-966.09,10.46 },
            [14] = { -1358.29,-863.75,15.93 },
            [15] = { -1467.39,-885.18,10.35 },
            [16] = { -1594.07,-811.02,9.88 },
            [17] = { -1750.62,-671.82,10.11 },
            [18] = { -1851.15,-561.73,11.27 },
            [19] = { -2143.36,-328.19,12.73 },
            [20] = { -2099.75,-218.97,19.43 },
            [21] = { -1876.31,-228.42,37.67 },
            [22] = { -1591.59,-320.57,48.69 },
            [23] = { -1440.46,-479.1,34.12 },
            [24] = { -1356.55,-587.85,28.93 },
            [25] = { -1301.91,-673.1,25.83 },
            [26] = { -1179.06,-838.01,14.01 },
            [27] = { -992.71,-1111.52,1.89 },
            [28] = { -736.31,-965.63,17.19 },
            [29] = { -518.96,-933.17,23.91 },
            [30] = { -456.83,-842.36,30.37 },
            [31] = { -351.46,-775.23,33.66 },
            [32] = { -221.44,-631.91,33.0 },
            [33] = { 145.09,-583.18,30.88 },
            [34] = { 410.12,-676.12,28.98 },
            [35] = { 514.25,-642.63,24.46 },
		}
	},
    [4] = {
		["initialCoord"] = { -1632.84,-944.11,7.65 },
		["time"] = 460,
		["stress"] = 5,
        ["payment"] = { 1000,1340 },
        ["maxPlayers"] = 8,
        ["raceCooldown"] = 600,
		["coordsRace"] = {
            [1] = {-1584.09,-819.93,9.53 },
            [2] = { -1853.87,-558.49,10.94 },
            [3] = { -1999.14,-394.8,11.9 },
            [4] = { -1605.0,-551.69,33.85 },
            [5] = { -1436.31,-487.59,33.34 },
            [6] = { -1345.47,-539.38,30.45 },
            [7] = { -1269.99,-476.32,32.79 },
            [8] = { -1085.42,-419.62,35.97 },
            [9] = { -1071.46,-485.88,35.92 },
            [10] = { -1198.59,-629.91,23.95 },
            [11] = { -1109.82,-678.51,20.07 },
            [12] = { -793.05,-534.59,24.39 },
            [13] = { -582.35,-546.58,24.7 },
            [14] = { -426.16,-653.89,36.57 },
            [15] = { -385.72,-822.53,38.2 },
            [16] = { -391.42,-1170.49,20.09 },
            [17] = { -386.6,-1356.19,21.64 },
            [18] = { -666.61,-1747.92,36.63 },
            [19] = { -760.7,-1795.82,28.04 },
            [20] = { -737.79,-1875.63,26.41 },
            [21] = { -691.33,-2011.74,25.13 },
            [22] = { -558.62,-2020.17,17.22 },
            [23] = { -401.75,-1847.08,20.21 },
            [24] = { -93.02,-1694.97,28.68 },
            [25] = { 6.97,-1578.62,28.68 },
            [26] = { 268.44,-1317.06,28.96 },
            [27] = { 376.32,-1285.56,31.87 },
            [28] = { 505.76,-1227.51,28.59 },
            [29] = { 477.92,-1129.6,28.77 },
            [30] = { 402.01,-1103.86,28.62 },
            [31] = { 374.98,-1049.0,28.61 },
            [32] = { 301.93,-1052.55,28.6 },
            [33] = { 269.75,-934.98,28.64 },
            [34] = { 310.39,-820.89,28.68 },
            [35] = { 293.78,-643.22,28.64 },
            [36] = { 52.81,-626.4,30.99 },
            [37] = { -12.1,-688.27,31.71 },
		}
	},
    [5] = {
		["initialCoord"] = { -1420.77,-961.2,6.59 },
		["time"] = 620,
		["stress"] = 5,
        ["payment"] = { 1000,1340 },
        ["maxPlayers"] = 8,
        ["raceCooldown"] = 600,
		["coordsRace"] = {
            [1] = { -1441.58,-947.76,7.55 },
            [2] = { -1533.59,-886.22,9.49 },
            [3] = { -1588.02,-885.42,9.11 },
            [4] = { -1697.68,-784.21,9.47 },
            [5] = { -1890.15,-618.44,10.93 },
            [6] = { -2019.27,-452.92,10.78 },
            [7] = { -2018.36,-400.69,10.24 },
            [8] = { -1723.01,-549.79,36.62 },
            [9] = { -1838.71,-417.16,44.07 },
            [10] = { -1913.41,-339.2,47.62 },
            [11] = { -1835.74,-308.99,42.17 },
            [12] = { -1640.64,-352.33,49.31 },
            [13] = { -1695.87,-442.15,40.61 },
            [14] = { -1670.16,-463.47,38.02 },
            [15] = { -1595.15,-402.37,42.17 },
            [16] = { -1586.01,-469.98,35.48 },
            [17] = { -1619.15,-508.29,34.9 },
            [18] = { -1501.74,-632.41,29.32 },
            [19] = { -1453.57,-628.86,30.03 },
            [20] = { -1399.41,-645.98,27.98 },
            [21] = { -1353.53,-676.74,24.89 },
            [22] = { -1311.44,-675.08,25.69 },
            [23] = { -1225.51,-789.66,16.8 },
            [24] = { -1096.35,-774.54,18.68 },
            [25] = { -1221.93,-593.92,26.61 },
            [26] = { -1195.98,-539.3,28.3 },
            [27] = { -1186.59,-467.77,32.57 },
            [28] = { -1116.42,-447.96,35.44 },
            [29] = { -1043.5,-476.55,36.17 },
            [30] = { -1046.85,-407.08,32.59 },
            [31] = { -1005.39,-386.42,37.12 },
            [32] = { -983.72,-315.91,37.07 },
            [33] = { -965.5,-277.52,37.73 },
            [34] = { -952.87,-300.29,38.02 },
            [35] = { -858.48,-257.45,38.79 },
            [36] = { -869.42,-213.07,38.53 },
            [37] = { -848.96,-162.12,37.08 },
            [38] = { -743.33,-69.21,41.08 },
            [39] = { -656.63,14.65,38.58 },
            [40] = { -691.44,41.99,42.52 },
            [41] = { -765.82,44.04,48.36 },
            [42] = { -862.11,82.78,51.35 },
            [43] = { -982.1,35.85,49.89 },
            [44] = { -1018.97,-165.58,37.08 },
            [45] = { -1354.96,12.56,52.36 },
            [46] = { -1385.02,134.16,55.04 },
            [47] = { -1325.93,80.13,53.7 },
            [48] = { -1331.31,-22.38,49.83 },
            [49] = { -1405.23,216.22,58.22 },
            [50] = { -1517.92,238.21,60.46 },
            [51] = { -1733.78,239.83,64.32 },
            [52] = { -1683.44,165.38,62.93 },
            [53] = { -1689.6,138.07,63.48 },
            [54] = { -1457.93,58.35,51.92 },
            [55] = { -1382.56,226.59,58.05 },
            [56] = { -1289.33,293.3,64.12 },
            [57] = { -1144.46,273.23,65.57 },
            [58] = { -1189.54,385.4,73.12 },
            [59] = { -1017.21,391.46,70.58 },
            [60] = { -999.95,343.89,70.22 },
            [61] = { -1150.65,337.13,68.74 },
		}
	},
    [6] = {
		["initialCoord"] = { -245.94,-259.41,48.57 },
		["time"] = 320,
		["stress"] = 5,
        ["payment"] = { 1000,1340 },
        ["maxPlayers"] = 8,
        ["raceCooldown"] = 900,
		["coordsRace"] = {
            [1] = { -191.0374, -215.6372, 48.05352 },
            [2] = { -50.20497, -191.8524, 51.60246 },
            [3] = { 64.75489, -187.619, 54.33969 },
            [4] = { 116.1542, -56.57301, 66.86323 },
            [5] = { 181.2229, -49.4675, 67.84074 },
            [6] = { 174.2, -122.5605, 60.85083 },
            [7] = { 244.8954, -231.9478, 53.47499 },
            [8] = { 448.7835, -338.3393, 47.00576 },
            [9] = { 281.7491, -518.3026, 42.72787 },
            [10] = { 207.9341, -708.2899, 34.73794 },
            [11] = { 146.2502, -712.4949, 32.56206 },
            [12] = { 85.11272, -660.7971, 31.04959 },
            [13] = { 181.4176, -593.9406, 29.21308 },
            [14] = { 407.0325, -714.9083, 28.73943 },
            [15] = { 377.5118, -849.5808, 28.77284 },
            [16] = { -74.7142, -719.4556, 33.51665 },
            [17] = { -121.7103, -661.2582, 34.81769 },
            [18] = { -266.9263, -616.2466, 32.70601 },
            [19] = { -349.7695, -724.6403, 33.40884 },
            [20] = { -355.7935, -899.7956, 30.5026 },
            [21] = { -271.8749, -989.2214, 30.4852 },
            [22] = { -303.8259, -1133.994, 22.93457 },
            [23] = { -549.4805, -1153.693, 19.02165 },
            [24] = { -688.9427, -1481.871, 10.28686 },
            [25] = { -919.393, -1782.671, 19.23616 },
            [26] = { -1013.733, -2100.74, 12.71114 },
            [27] = { -845.6044, -2038.046, 8.749431 },
            [28] = { -729.697, -2065.064, 8.334114 },
            [29] = { -650.7855, -2071.572, 8.314284 },
            [30] = { -601.053, -2054.665, 5.464193 },
            [31] = { -481.0005, -2147.04, 8.725636 },
            [32] = { -317.5307, -2158.262, 9.724993 },
            [33] = { -215.2274, -2162.397, 15.24786 },
            [34] = { -111.3842, -2030.812, 17.46939 },
		}
	},
    [7] = { 
		["initialCoord"] = { 1268.92, -3218.15, 5.2 },
		["time"] = 860,
		["stress"] = 5,
        ["payment"] = { 7500,10000 },
        ["maxPlayers"] = 10,
        ["raceCooldown"] = 2400,
		["coordsRace"] = {
			[1] = {	1230.45, -3218.34, 5.12},
			[2] = {	1076.93, -3200.15, 5.22},
			[3] = {	1054.15, -3115.18, 5.22},
			[4] = {	950.95,-3087.95,5.91},
			[5] = {	755.81, -2999.1, 5.2},
			[6] = {	737.01, -2632.46, 15.87},
			[7] = {	830.25, -2395.6, 27.86},
			[8] = {	853.07, -2260.63, 29.7},
			[9] = {	776.37,-2220.59,29.3},
			[10] = { 892.56, -1862.18, 29.96},
			[11] = { 967.12, -1765.18, 30.64},
			[12] = { 1115.67, -1660.83, 31.82},
			[13] = { 1071.81, -1347.58, 27.95},
			[14] = { 1039.48, -967.12, 29.84},
			[15] = { 765.67, -607.21, 36.57},
			[16] = { 587.81, -470.96, 43.68},
			[17] = { 576.49, -355.26, 42.98},
			[18] = { 525.16, -241.95, 48.52},
			[19] = { 594.53, -79.56, 70.41},
			[20] = { 641.26, 40.44, 86.66},
			[21] = { 383.07, 133.96, 102.34},
			[22] = { -35.83, 280.87, 105.42},
			[23] = { -115.39, 431.68, 112.79},
			[24] = { -290.3, 441.21, 107.46},
			[25] = { -493.07, 572.66, 119.98},
			[26] = { -470.33, 753.08, 167.11},
			[27] = { -645.73, 912.06, 226.22},
			[28] = { -708.28, 1110.35, 257.71},
			[29] = { -773.2, 1644.21, 203.59},
			[30] = { -834.75, 1867.9, 161.88},
			[31] = { -1148.84, 2207.81, 78.89},
			[32] = { -1521.55, 2107.88, 56.54},
			[33] = { -1578.81, 2353.88, 44.05},
			[34] = { -1882.95, 2384.63, 33.75},
			[35] = { -2321.08, 2248.03, 32.41},
			[36] = { -2609.9, 2313.96, 27.65},
			[37] = { -2690.39, 2376.57, 16.1},
			[38] = { -2569.17, 3319.76, 12.95},
			[39] = { -2323.35, 4107.29, 34.78},
			[40] = { -2259.07, 4336.7, 43.42},
			[41] = { -1895.01, 4480.71, 27.35},
			[42] = { -1490.56, 4303.47, 4.18},
			[43] = { -1012.35, 4355.45, 11.29},
			[44] = { -711.56, 4402.75, 22.0},
			[45] = { -270.13, 4225.97, 43.42},
			[46] = { -21.04, 4437.73, 57.52},
			[47] = { 162.64, 4426.47, 75.29},
			[48] = { 54.7, 4550.29, 99.79},
			[49] = { -150.67, 4631.31, 126.18},
			[50] = { -595.95, 5030.05, 139.78},
			[51] = { -733.72, 5205.92, 102.44},
			[52] = { -941.21, 5273.78, 80.93},
			[53] = { -655.01, 5338.32, 61.27},
			[54] = { -777.8, 5433.19, 35.69},
			[55] = { -786.96, 5534.1, 33.33},
			[56] = { -593.21, 6109.46, 7.0},
			[57] = { -482.75, 6342.05, 10.77},
			[58] = { -251.54, 6488.54, 10.71},
			[59] = { -19.24, 6719.02, 16.15},
			[60] = { 297.58, 6734.14, 14.97},
			[61] = { 484.14, 6583.67, 26.12},
			[62] = { 771.7, 6498.48, 24.53},
			[63] = { 1747.58, 6349.11, 34.96},
			[64] = { 2128.58, 6020.43, 50.56},
			[65] = { 2342.88, 5807.38, 46.02},
			[66] = { 2560.8, 5274.09, 44.04},
			[67] = { 2472.75, 5111.13, 45.73},
			[68] = { 2232.17, 5171.16, 58.47},
			[69] = { 2074.64, 5019.34, 40.15},
			[70] = { 1983.05, 4879.17, 43.24},
			[71] = { 2123.18, 4807.04, 40.6},
			[72] = { 2178.68, 4751.27, 40.44},
			[73] = { 2385.06, 4659.12, 35.84},
			[74] = { 2519.69, 4578.08, 32.92},
			[75] = { 2647.05, 4644.05, 34.33},
			[76] = { 2710.65, 4505.32, 40.68},
			[77] = { 2698.74, 4376.68, 46.38},
			[78] = { 2491.27, 4097.13, 37.53},
			[79] = { 2082.9, 3691.29, 34.19},
			[80] = { 2135.95, 3525.05, 43.99},
			[81] = { 2232.71, 3286.86, 46.45},
			[82] = { 2103.97, 3275.48, 45.36},
			[83] = { 1837.41, 3248.3, 43.64},
			[84] = { 1434.89, 3180.01, 39.8},
        }
	},
    [8] = { 
		["initialCoord"] = { -1840.71,2979.7,32.81 },
		["time"] = 520,
		["stress"] = 5,
        ["payment"] = { 7500,10000 },
        ["maxPlayers"] = 10,
        ["raceCooldown"] = 900,
		["coordsRace"] = {
            [1] = { -1864.16,3033.37,32.2},
            [2] = { -1808.99,3048.79,32.2},
            [3] = { -1772.9,2924.56,32.19},
            [4] = { -1875.51,2852.23,32.19},
            [5] = { -2097.16,2910.26,32.2},
            [6] = { -2294.7,3100.91,32.2},
            [7] = { -2222.09,3302.17,32.2},
            [8] = { -2190.26,3367.28,32.59},
            [9] = { -1723.05,3129.72,32.38},
            [10] = { -1606.67,2814.3,17.03},
            [11] = { -1330.13,2561.53,17.06},
            [12] = { -1349.06,2374.71,33.68},
            [13] = { -1493.59,2057.31,61.01},
            [14] = { -1624.15,1084.37,152.03},
            [15] = { -1451.5,833.57,183.56},
            [16] = { -888.29,1018.88,225.36},
            [17] = { -614.5,887.12,217.71},
            [18] = { -466.24,550.79,119.71},
            [19] = { -101.74,423.99,112.56},
            [20] = { 119.87,305.67,110.44},
            [21] = { 214.43,286.06,104.94},
            [22] = { 175.97,118.93,94.79},
            [23] = { 16.63,12.83,69.93},
            [24] = { -142.71,-312.56,38.01},
            [25] = { -539.92,-329.44,34.56},
            [26] = { -656.56,-290.08,34.99},
            [27] = { -763.38,-253.47,36.47},
            [28] = { -930.88,-308.8,38.78},
            [29] = { -1114.63,-282.11,37.18},
            [30] = { -1129.42,-141.2,38.35},
            [31] = { -1326.6,-96.85,48.89},
            [32] = { -1357.65,-216.91,43.1},
            [33] = { -1400.85,-292.39,43.07},
            [34] = { -1534.6,-304.46,47.69},
            [35] = { -1690.02,-506.36,37.17},
            [36] = { -1909.22,-452.31,21.41},
            [37] = { -1936.01,-509.75,11.21},
            [38] = { -1133.72,-662.34,10.86},
            [39] = { -718.38,-551.32,31.31},
            [40] = { -679.54,-651.95,30.72},
            [41] = { -744.26,-618.23,29.61},
            [42] = { -689.41,-608.0,24.69},
            [43] = { -663.51,-615.49,24.69},
            [44] = { -487.27,-581.34,24.74},
            [45] = { -448.64,-708.5,28.91},
            [46] = { -454.17,-820.04,30.02},
        }
	},
    [9] = { 
        ["initialCoord"] = { 632.12,592.69,128.92 },
        ["time"] = 360,
        ["stress"] = 5,
        ["payment"] = { 1000,1340 },
        ["maxPlayers"] = 10,
        ["raceCooldown"] = 600,
        ["coordsRace"] = {
            [1] = { 714.33,622.27,128.24},
            [2] = { 792.16,587.67,125.11},
            [3] = { 914.0,479.52,120.48},
            [4] = { 791.53,342.54,115.02},
            [5] = { 619.49,361.57,115.68},
            [6] = { 496.56,339.25,133.71},
            [7] = { 392.44,438.09,142.49},
            [8] = { 321.29,567.2,153.83},
            [9] = { 291.73,672.0,164.92},
            [10] = { 307.99,846.09,192.42},
            [11] = { 411.17,881.55,198.28},
            [12] = { 512.49,851.67,197.4},
            [13] = { 638.47,779.1,204.13},
            [14] = { 820.05,954.86,237.71},
            [15] = { 973.64,855.74,203.95},
            [16] = { 936.13,662.12,172.55},
            [17] = { 1099.46,807.96,152.29},
            [18] = { 1236.05,978.11,141.8},
            [19] = { 1153.94,1137.7,171.66},
            [20] = { 1175.76,1359.9,150.12},
            [21] = { 1050.55,1638.99,164.71},
            [22] = { 782.06,1710.26,175.92},
            [23] = { 434.05,1778.37,232.57},
            [24] = { 144.68,1504.99,237.79},
            [25] = { 245.34,1280.52,233.81},
            [26] = { 274.86,1119.76,218.99},
            [27] = { 245.92,948.32,210.7},
            [28] = { 57.29,1029.68,217.69},
            [29] = { -59.57,1054.72,222.45},
            [30] = { -159.24,986.78,235.09},
            [31] = { -104.66,860.63,235.73},
        }
    },
}
-----------------------------------------------------------------------------------------------------------------------------------------
--  ADD PLAYER IN RACE
-----------------------------------------------------------------------------------------------------------------------------------------
function hiro.addPlayerInRace(raceName)
    if not inprogressRace[raceName] then
        if preRaceStart[raceName] then
            for k,v in pairs(preRaceStart[raceName])  do
                if v == source then
                    return
                end
            end
        end

        if preRaceStart[raceName] then
            if #preRaceStart[raceName] >= races[raceName]["maxPlayers"] then
                TriggerClientEvent("Notify",source,"vermelho", "Máximo de <b>"..races[raceName]["maxPlayers"].."</b> pessoas na corrida.", 5000)
                return
            end
        end

        if not raceStarter[raceName] then 
            raceStarter[raceName] = source
        else
            TriggerClientEvent("Notify",source,"amarelo", "Aguarde o dono da corrida inciar.", 5000, 'info')
        end
        
        if preRaceStart[raceName] then
            table.insert(preRaceStart[raceName],source)
            hiro.freezeRace(raceName,true)
        else
            preRaceStart[raceName] = {source}
        end
    else
        TriggerClientEvent("Notify",source,"vermelho", "<b>Essa corrida ja foi iniciada aguarde o termino da mesma.</b>", 5000)
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
--  UNFREEZE
----------------------------------------------------------------------------------------------------------------------------------------
function hiro.freezeRace(raceName,boolean)
    for k,v in pairs(preRaceStart[raceName]) do
        async(function()
            TriggerClientEvent("vrp_race:freeze",v,boolean)
        end)
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
--  CHECK START
----------------------------------------------------------------------------------------------------------------------------------------
function hiro.checkStart(raceName)
    if raceStarter[raceName] == source then 
        TriggerClientEvent("vrp_race:freeze",source,true)
        if vRP.request(source,"Corrida","Deseja começar a corrida somente com essas pessoas?",120) then
            for k,v in pairs(preRaceStart[raceName]) do
                local user_id = vRP.getUserId(vPLAYER)
                TriggerClientEvent("vrp_race:start",v)
                TriggerEvent("vrp_blipsystem:serviceEnter",v,"Corredor",75)
                inprogressRace[raceName] = true
            end

            Citizen.Wait(10000)

            local copAmount = vRP.numPermission("Police")
            for k,v in pairs(copAmount) do
                async(function()
                    TriggerClientEvent("NotifyPush",v,{ code = 94, title = "Recebemos um relato de um corredor ilegal", rgba = {0,150,90} })
                end)
            end
            raceStarter[raceName] = nil
        else
            hiro.freezeRace(raceName,false)
            raceStarter[raceName] = nil
            preRaceStart[raceName] = nil
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTION CHECKILLEGAL
-----------------------------------------------------------------------------------------------------------------------------------------
function hiro.checkTicket()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRPC.inVehicle(source) then
            if vRP.wantedReturn(user_id) or vRP.wantedReturn(user_id) then
                TriggerClientEvent("Notify",source,"vermelho","Você está sendo <b>procurado</b> ou está em <b>repouso</b>.",8000)
                return false
            end

            if vRP.hasPermission(user_id,{"Police","Paramedic","Mechanic","Mechanic02"}) then
                return false
            end

            if vRP.getInventoryItemAmount(user_id,"raceticket") >= 1 then
                return true
            else
                TriggerClientEvent("Notify",source,"amarelo","Você precisa de <b>1x Ticket</b> para inciar esta corrida.",8000,'info')
                return false
            end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
--  COMPARE POSITION
----------------------------------------------------------------------------------------------------------------------------------------
function compareRacePositions(k1,k2)
    if k1.checkpoint and k2.checkpoint and k1.distance and k2.distance then
        if k1.checkpoint == k2.checkpoint then
            return k1.distance < k2.distance
        end
        return k1.checkpoint > k2.checkpoint
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
--  UPDATE LEADERBOARD
----------------------------------------------------------------------------------------------------------------------------------------
function hiro.updateLeaderboard(raceName,checkpoint,distance)
    if preLeaderboard[raceName] then
        preLeaderboard[raceName][source] = {checkpoint = checkpoint, distance = distance}
    else
        preLeaderboard[raceName] = { [source] = { checkpoint = checkpoint, distance = distance } }
    end

    if preLeaderboard[raceName][source] then
        local sorted = {}
        for k,v in pairs(preLeaderboard[raceName]) do
            local var = v
            var['source'] = k
            table.insert(sorted,var)
        end
        table.sort(sorted,compareRacePositions)
        for k,v in ipairs(sorted) do
            if source == v.source then 
                TriggerClientEvent("vrp_race:sendPosition",v.source,k,#sorted)
            end
        end
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
--  PAYMENT
----------------------------------------------------------------------------------------------------------------------------------------
function hiro.PayRace(raceName,finalTime,mHash)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
        local maxPayment = 25000
        local payMin = 5000
        local payMax = 6000
		local random = math.random(payMin,payMax)
		local Cop = vRP.numPermission("Police")
		local paymentCop = parseInt(random*#Cop)
		local paymentNotCop = parseInt(random)

		if parseInt(#Cop) == 0 then
			if paymentNotCop > maxPayment then
				vRP.generateItem(user_id,"dollars2",maxPayment,true)
			else
				vRP.generateItem(user_id,"dollars2",paymentNotCop,true)
			end
		else
			if paymentCop > maxPayment then
				vRP.generateItem(user_id,"dollars2",maxPayment,true)
			else
				vRP.generateItem(user_id,"dollars2",paymentCop,true)
			end
		end

        vRP.removeInventoryItem(user_id,"raceticket",1,true)
        vRP.wantedTimer(user_id,240)
		updateRank(user_id,raceName,finalTime,mHash)
        TriggerEvent("blipsystem:Exit",source)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
--  REVOME PLAYER FROM RACE
----------------------------------------------------------------------------------------------------------------------------------------
function hiro.removePlayerFromRace(raceName,position)
    if preRaceStart[raceName] then
        local source = source
        local user_id = vRP.getUserId(source)
        for k,v in pairs(preRaceStart[raceName]) do
            table.remove(preRaceStart[raceName],k)
            preLeaderboard[raceName][source] = nil
            TriggerEvent("vrp_blipsystem:serviceExit",source)
        end
        if #preRaceStart[raceName] == 0 then
            inprogressRace[raceName] = nil
            preLeaderboard[raceName] = nil
            preRaceStart[raceName] = nil
            globalCooldown[raceName] = races[raceName]["raceCooldown"]
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
--  CHECK GLOBAL COOLDOWN
-----------------------------------------------------------------------------------------------------------------------------------------
function hiro.globalCooldown(raceName)
    if globalCooldown[raceName] ~= nil then
        TriggerClientEvent("Notify",source,"amarelo", "Aguarde "..completeTimers(parseInt(globalCooldown[raceName])), 5000, 'info')
        return false
    end
    return true
end

Citizen.CreateThread(function()
	while true do
        for k,v in pairs(globalCooldown) do 
            if globalCooldown[k] > 0 then
                globalCooldown[k] = globalCooldown[k] - 1
                if globalCooldown[k] <= 0 then
                    globalCooldown[k] = nil
                end
            end
        end
		Citizen.Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /defuse
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_race:defuseBomb")
AddEventHandler("vrp_race:defuseBomb",function()
    local source = source
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,{"Police","actionPolice"})  then
		local nplayer = vRPC.nearestPlayer(source,6)
		if nplayer then
			TriggerClientEvent('vrp_race:defuseRace',nplayer)
            TriggerClientEvent("Notify",source,"amarelo", "Você desarmou a <b>Bomba</b> com sucesso.", 5000, 'sucesso')
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawn",function(user_id,source)
	vCLIENT.updateRaces(source,races)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEBUG
-----------------------------------------------------------------------------------------------------------------------------------------
-- local debug = false

-- -- Citizen.CreateThread(function()
-- 	while true do
-- 		Citizen.Wait(1000)
--         if not debug then
--             debug = true
-- 		    vCLIENT.updateRaces(-1,races)
--         end
--    end
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARE RANKS
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("explosiverace/get_race_rank_by_user_id","SELECT * FROM vrp_races WHERE user_id = @user_id AND race_id = @race_id")
vRP.prepare("explosiverace/insert_race_rank_by_user_id","INSERT INTO vrp_races (race_id, user_id, final_time, hash_vehicle) VALUES (@race_id, @user_id, @final_time, @hash_vehicle)")
vRP.prepare("explosiverace/update_race_rank_by_user_id","UPDATE vrp_races SET final_time = @final_time, hash_vehicle = @hash_vehicle WHERE race_id = @race_id AND user_id = @user_id")
vRP.prepare("explosiverace/get_top_players","SELECT * FROM vrp_races WHERE race_id = @race_id ORDER BY final_time ASC LIMIT @limit")
-----------------------------------------------------------------------------------------------------------------------------------------
-- GET TOP RANK PLAYERS (user_id, race_id, final_time) 
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("rank",function(source,args,rawCommand)
    local source = source
	local user_id = vRP.getUserId(source)
	local count = 0
    local raceId = args[1]
    local limit = 5
	local topPlayers = vRP.query("explosiverace/get_top_players",{ user_id = parseInt(user_id), race_id = parseInt(raceId), limit = parseInt(limit) })
	local myTime = vRP.query("explosiverace/get_race_rank_by_user_id",{ user_id = parseInt(user_id), race_id = parseInt(raceId) })
	
	playersNames[user_id] = ""
	myNames[user_id] = ""
	if raceId then
		for k,v in pairs(topPlayers) do
			local identity = vRP.getUserIdentity(parseInt(v.user_id))
			count = count + 1
			local playerName = "<b>"..count.."° "..identity.name.." "..identity.name2.."</b><br> Tempo: "..completeTimers(parseInt(v.final_time)).."<br> Modelo: <b>"..vRP.vehicleHashName(v.hash_vehicle).."</b><br>  <br>"

			playersNames[user_id] = playersNames[user_id]..playerName
		end
		for k,v in pairs(myTime) do
			local myPosition = "<b>Seu Desempenho</b><br> Tempo: "..completeTimers(parseInt(v.final_time)).."<br> Modelo: <b>"..vRP.vehicleHashName(v.hash_vehicle).."</b><br>"

			myNames[user_id] = myNames[user_id]..myPosition
		end
        TriggerClientEvent("Notify",source,"amarelo",playersNames[user_id], 20000, 'info')
        TriggerClientEvent("Notify",source,"amarelo",myNames[user_id], 20000, 'info')
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATERANK (user_id, race_id, final_time) 
-----------------------------------------------------------------------------------------------------------------------------------------
function updateRank(user_id,raceName,finalTime,mHash)
	local playerRankQuery = vRP.query("explosiverace/get_race_rank_by_user_id",{ user_id = parseInt(user_id), race_id = parseInt(raceName) })
	if #playerRankQuery == 0 and finalTime > 0 then
		vRP.execute("explosiverace/insert_race_rank_by_user_id",{ user_id = parseInt(user_id), race_id = parseInt(raceName), final_time = parseInt(finalTime), hash_vehicle = mHash })
		return
	end

	local playerRank = playerRankQuery[1]

	if playerRank and finalTime > 0 and finalTime < playerRank.final_time then
		vRP.execute("explosiverace/update_race_rank_by_user_id",{ user_id = parseInt(user_id), race_id = parseInt(raceName), final_time = parseInt(finalTime), hash_vehicle = mHash })
	end
end