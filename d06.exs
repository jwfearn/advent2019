# https://adventofcode.com/2019/day/6

defmodule El do
  defstruct [
    parent: nil,
    children: [],
    depth: nil
  ]
end

defmodule Tree do
  @root_name "COM"

  def new() do
    %{
      @root_name => %El{
        depth: 0
      }
    }
  end

  def root(tree), do: tree[@root_name]

  def orbits(tree) do
    tree
    |> Map.values
    |> Enum.reduce(0, &(&1.depth + &2))
  end

  def transfers(tree, name1, name2) do
    %{}
    |> tally(path(tree, name1))
    |> tally(path(tree, name2))
    |> Enum.reduce(
         0,
         fn {_, tally}, sum ->
           if tally == 1, do: sum + 1, else: sum
         end
       )
    |> Kernel.-(2)
  end

  defp tally(tallies, names) do
    Enum.reduce(names, tallies, &Map.put(&2, &1, Map.get(&2, &1, 0) + 1))
  end

  def path(tree, name, path \\ [])
  def path(_, nil, path), do: path
  def path(tree, name, path), do: path(tree, tree[name].parent, [name | path])

  def build(lines) do
    lines
    |> String.split("\n", trim: true)
    |> Stream.map(&String.split(&1, ")", trim: true))
    |> Enum.reduce(Tree.new(), &Tree.add/2)
    |> update_depths
  end

  def add([parent_name, child_name], tree) do
    parent = Map.get(tree, parent_name, %El{})
    child = Map.get(tree, child_name, %El{})
    child = %El{child | parent: parent_name}
    parent = %El{parent | children: [child_name | parent.children]}
    tree
    |> Map.put(parent_name, parent)
    |> Map.put(child_name, child)
  end

  defp update_depths(tree), do: update_depths(tree, root(tree))
  defp update_depths(tree, %El{children: []}), do: tree
  defp update_depths(tree, %El{children: children, depth: depth}) do
    children
    |> Enum.reduce(tree, &update_depth(&2, &1, depth))
  end

  defp update_depth(tree, child_name, parent_depth) do
    child = %El{Map.fetch!(tree, child_name) | depth: parent_depth + 1}
    tree
    |> Map.put(child_name, child)
    |> update_depths(child)
  end
end

defmodule D6 do
  def orbits(lines) do
    lines
    |> Tree.build
    |> Tree.orbits
  end

  def transfers(lines, a, b) do
    lines
    |> Tree.build
    |> Tree.transfers(a, b)
  end
end

ExUnit.start()

defmodule D6Test do
  use ExUnit.Case

  test "a" do
    actual =
      """
      COM)B
      B)C
      C)D
      D)E
      E)F
      B)G
      G)H
      D)I
      E)J
      J)K
      K)L
      """
      |> D6.orbits
    assert actual == 42
  end

  test "b" do
    actual =
      """
      COM)B
      B)C
      C)D
      D)E
      E)F
      B)G
      G)H
      D)I
      E)J
      J)K
      K)L
      K)YOU
      I)SAN
      """
      |> D6.transfers("YOU", "SAN")
    assert actual == 4
  end

  test "part 1", do: assert D6.orbits(input()) == 268504

  test "part 2", do: assert D6.transfers(input(), "YOU", "SAN") == 409

  defp input do
    """
    TT5)Y6Q
    ZBC)Z2R
    8MQ)51V
    39F)L8J
    CYW)CS5
    RB2)GZC
    X25)CQ3
    B16)L7S
    KGG)2D8
    8VW)C7H
    FZB)39H
    8HG)M9D
    QGL)TJK
    2MG)W4P
    VQ2)GVC
    BCM)QGL
    JN3)J2B
    3LR)CSL
    YZ4)R6P
    GH6)YBH
    BDF)K4C
    YBH)TZ1
    51P)T32
    44W)NP4
    Z5G)PP3
    NGS)4W5
    G7T)RFK
    G6Y)ZQT
    WQP)QHW
    3TD)5GS
    32K)VH7
    S62)NWT
    QSX)V34
    LK6)6K8
    DYD)VD1
    VWH)MKN
    LYH)PNG
    F3T)LXJ
    PVZ)4DF
    VM5)N11
    PPM)141
    MCT)WZT
    W4P)B6K
    T6T)2F7
    KQV)RXJ
    B11)518
    VN8)HMG
    13N)77L
    1S5)Q8W
    CCY)18N
    M42)WWT
    L81)7RF
    649)1DB
    LCW)JXZ
    4L3)PRF
    T5N)1R7
    XXN)DWV
    4DF)8MQ
    NSC)4QT
    CZ9)QNF
    FWX)9MS
    78N)3KX
    2V8)52L
    982)2CQ
    18F)2YW
    XH2)L9S
    M38)18F
    MQ2)RKW
    P3K)RNH
    2YL)N1X
    PLX)5KT
    9G6)WTT
    VNT)X7Y
    PYW)WLB
    LSC)TN4
    ZF1)PSG
    9RH)GVY
    HYY)FV9
    VLW)X58
    3W1)2ZB
    R5C)VYN
    7G4)YRT
    M73)JF2
    LW9)7Y8
    B4Z)4ND
    MZN)X8S
    VDD)F3T
    VSH)LWB
    GT8)LFY
    GJC)YTC
    7TW)HSG
    XR5)YR5
    QV9)PLB
    4GV)SXV
    CD7)ZHT
    R2V)BPF
    2CQ)FH5
    RBW)4MW
    8X2)RP2
    KZJ)ZQQ
    XTN)7J1
    88M)92X
    J53)GC7
    LML)4JN
    F2T)D67
    MNJ)2NL
    J4V)J7M
    1NH)983
    XC7)WVK
    74W)B1S
    MC6)HXF
    FGT)2SC
    X5R)TTC
    8CV)4XH
    XBC)21J
    T1F)KXT
    YRK)JDD
    F9Q)HHB
    3FD)Z44
    8XG)RRQ
    DBC)H4S
    WWT)6G1
    GG8)1VV
    6TR)G6Y
    716)R9Q
    3DB)RN6
    2GH)KFR
    PR2)C3C
    XCG)4YM
    G76)VFG
    CFL)4TS
    3HW)PWQ
    XWD)H3D
    3FH)X3T
    TCH)PYW
    B1S)935
    F5X)MQ3
    JHW)NSM
    GQG)6LS
    21J)FD7
    F7P)TTF
    L98)42C
    5LM)31K
    2YW)R69
    K79)48K
    2TP)VF1
    W8V)HTR
    Q9L)55M
    4D8)RF1
    R2S)5HG
    DNH)QK4
    RCL)LYT
    Y3Y)5B2
    R64)6YS
    CWQ)BT5
    4RS)V2B
    YX6)B1K
    S7K)GXV
    MJM)N9F
    PB5)8HG
    7NF)XFF
    4KN)35T
    KY1)WB4
    B4Z)4W4
    TGG)BKS
    J2B)1RV
    12Y)WPX
    266)LYX
    BYT)VNS
    7V2)5BX
    F8D)4GR
    NWT)S6L
    6LS)C97
    HFL)R7B
    1C8)PYT
    CGG)5KB
    788)D1D
    2S5)65K
    B52)5ZD
    JF2)HF4
    BTS)KJ3
    K5S)5P3
    QFC)GR6
    QZP)KN6
    4NS)9XS
    6B7)QV3
    4MW)VN8
    423)4CT
    BCL)PS3
    4CT)ZQB
    VFG)B8T
    6ZZ)K5R
    3D2)154
    KPC)YTN
    PWR)4NS
    NTX)KHK
    PB5)X57
    2F7)F9C
    T1Z)TGG
    8D2)CS1
    M1R)C3N
    TZ1)VV8
    9JB)11B
    7LJ)CFL
    R69)MF7
    3LZ)59X
    BTB)VDP
    GTK)69Q
    J4K)D2Q
    PWQ)9Y2
    T1L)NTL
    HRJ)BCM
    WMD)NQC
    VNP)TQR
    17Y)HSJ
    C7H)PY8
    RG5)QTD
    3SV)MPC
    338)LLF
    3S9)JTC
    YTC)7NS
    ML9)X8F
    VVQ)25Y
    4JY)JCP
    9YS)BN9
    QNX)DVZ
    WYP)RF4
    KZ8)266
    QWH)4P1
    HHB)4S1
    7FD)N7K
    FZT)LYH
    MPC)MW6
    B99)HJX
    YZM)5XH
    5ZW)SHX
    BJW)Q15
    Q3N)BPP
    XWD)21Q
    669)8D2
    6MG)VN6
    6MG)J4K
    TM1)HD5
    2L9)KKM
    43Z)HGL
    SXG)F5Z
    TTC)PKW
    NQC)T3S
    JCP)JW2
    2JY)5ZW
    54Q)797
    2MX)RGS
    39H)B16
    F85)23N
    VL2)RF9
    FDS)X7N
    4W5)3X7
    FJZ)QWW
    3VN)KHP
    9J1)51T
    YZK)PKF
    KHK)C7W
    37K)QMV
    JTC)L11
    CJZ)44W
    PYH)NRY
    5P3)98X
    8B9)4MZ
    T35)P93
    GC7)YK1
    VYN)3JZ
    WWR)6B3
    ZYJ)8PB
    164)ZPD
    HBD)JW8
    4ND)KKP
    6VV)QSX
    FFM)LR2
    RXJ)KL9
    V34)SQD
    9Q3)RZN
    23S)WLW
    6VM)2W7
    VTX)YHN
    LKV)85W
    QNF)FY1
    ZLJ)SNK
    6N7)6KX
    NY1)L1J
    9M5)WW9
    365)TWR
    S35)HNN
    ZKG)5K6
    TKZ)F2T
    FWT)W8V
    83W)B8R
    3L9)Y5D
    WLW)DX3
    MN3)SNY
    WT8)Z84
    TD2)YMJ
    4P1)CV4
    HY8)CGP
    DYQ)DBC
    HD5)4VL
    333)CCY
    DD5)ZZ9
    PR2)37K
    C7B)YOU
    8JH)H1G
    4MZ)CYZ
    NM6)KVD
    1V5)T2F
    RZN)9RH
    2HK)FT1
    GNY)M9V
    F2T)GP7
    LV1)3SV
    9JF)F4N
    Z3X)G5T
    ZMC)G7T
    M8Y)L2R
    NV1)792
    SNY)RB2
    MTF)NG2
    DRV)TRH
    BK7)S4B
    FBV)CWQ
    TPF)5LV
    2W7)RRH
    MX2)GNF
    TLP)4DW
    XKZ)VXF
    QSC)2BR
    TN4)LQR
    2VW)8FQ
    JDD)7KN
    T3M)75X
    68M)NQ1
    NCL)TD1
    184)F5X
    R74)HQY
    C84)92Y
    64V)Y7G
    C7W)T3M
    CPW)CTK
    L5P)F1Q
    4W4)GQB
    M6F)CR2
    CVG)GH6
    VFW)QWH
    3JH)MKB
    F2K)94W
    RCT)M1R
    LYX)QKN
    F1Q)365
    KFG)B5T
    NVV)GJ6
    SSZ)2GP
    RRQ)3NZ
    4VL)JXD
    2PX)GCF
    H5S)TCW
    WLS)ZM3
    S2V)K6T
    X9J)TZ9
    58Z)8ZH
    6D6)YX2
    8N3)4GF
    1TS)92B
    RYQ)QRG
    NYF)KPC
    DRT)XK4
    35K)W3Y
    GVC)7G8
    F5Z)ZC1
    XKZ)9JF
    YYQ)HYY
    292)2XF
    5XW)8B9
    XC8)SWP
    5HY)VBN
    S4W)29X
    MNR)X94
    454)W3Q
    L9W)1MZ
    BDD)2VW
    K89)2YQ
    5GS)3LZ
    PC2)VKK
    TLP)BQV
    H4S)KX3
    YK3)KYH
    SBR)68N
    3JZ)S4W
    RN6)LKH
    KJ3)ZGQ
    3YZ)X7Z
    3NZ)LPV
    F31)M2F
    LFL)F5K
    2TP)MZN
    358)XFX
    M4L)LY4
    8L3)2DY
    1MR)QTY
    N96)SBR
    BW5)F65
    NWT)VDD
    GZB)L9N
    6YS)K8C
    HBQ)G2Z
    PP3)7G4
    TRT)54Q
    PTH)TWQ
    VBN)VSH
    TKD)FQQ
    222)NM6
    3DG)4FS
    M9V)854
    V2Z)SC4
    65Z)SD9
    VN8)YLZ
    3T4)PL7
    LR2)W2D
    DR1)M2G
    7XC)VTB
    C98)S3Q
    SC4)5YS
    ZQB)NW5
    2JY)5G3
    V5Q)WF7
    2C4)ZW3
    G2W)GZ6
    KJS)JHW
    Z6J)TZY
    121)RCL
    636)XX4
    CS2)9JZ
    D3J)Y3Z
    QC3)CYW
    H8C)12Y
    SBL)681
    NQX)RTC
    LQR)HS2
    YB6)KGG
    NVY)GNY
    L2R)11P
    HY8)235
    SXV)QYB
    Z5V)W1L
    9GJ)17Y
    SPR)2C4
    YHN)N5G
    ZPD)ZWR
    DRM)4PL
    NTL)S67
    YX2)HFL
    8PW)LDD
    1DB)RG5
    K8P)7QT
    X94)DJF
    MC7)SCW
    648)KDQ
    H3D)333
    R2R)78N
    95D)C61
    G1S)23S
    TM1)PL8
    RNH)YBR
    G6J)S6P
    797)4JY
    5K6)W4X
    J2C)83W
    2LN)ZM8
    C1N)8BF
    14R)WWR
    7X3)MY1
    68N)DR1
    HBQ)SY6
    YBW)ZKR
    NQX)W7Y
    DKZ)PR2
    SM6)7XC
    HNN)3HN
    S2T)L76
    12D)BX7
    JF2)MJM
    QK4)PJK
    M2F)J46
    X91)QF9
    JXZ)PVJ
    H5S)8QW
    SPD)BW5
    GCF)LY1
    SNC)TQS
    KDR)BXJ
    SNR)WP5
    YBS)R5L
    S3C)G36
    YR5)F2K
    6VH)F9Q
    8R9)184
    RBX)68M
    DVZ)7F7
    XRN)GBT
    V74)JH2
    C9L)SM6
    TQR)PY4
    WP5)BYT
    QF8)YWN
    W7N)S7K
    8MF)VVQ
    1V3)J3D
    983)PSM
    J68)F7S
    JXD)B5Z
    PQR)PYR
    57F)6C3
    S3Q)8R9
    JK4)S9T
    54Q)GL5
    PLB)WRW
    BGL)VX5
    4NZ)P3K
    XQC)788
    X57)8VB
    J3C)VL2
    X7R)3VN
    DWV)XQC
    J6M)DB7
    BX7)BMQ
    J9Z)W1Y
    22C)C7B
    2P7)XJS
    NRM)66R
    27Z)TNT
    1Q4)KGK
    1RV)3VT
    DXN)LLS
    PYH)38C
    G3N)CVV
    4H9)QNX
    FPJ)WDF
    7JM)LSC
    SHX)LV1
    L9S)FGD
    D2G)FKS
    SZ6)G2W
    47G)LML
    2PX)GJ5
    NZ7)648
    5HG)4SH
    91P)JTP
    2RM)RDJ
    QTD)14Y
    B6K)765
    F7D)3WF
    2C5)9KS
    RP2)T5Q
    PVW)GCR
    KSZ)XKV
    2NL)SPD
    3KX)BTS
    QYB)KQV
    V5W)V5Q
    4DN)PVW
    DQ5)BGL
    K4C)SNR
    4XH)Z54
    7WZ)XC8
    GTK)12D
    J46)7PX
    PKT)PKR
    WLJ)6N7
    DJ2)JR1
    4FB)649
    DRK)D58
    1TH)Q6N
    YWN)WHX
    77T)M8B
    3KX)L34
    DVG)1VL
    7RF)JHS
    W4X)NG5
    7LY)6L8
    97K)XC7
    Q49)3LB
    94F)YJQ
    G28)MJS
    SJX)G6B
    FLT)C71
    7Y8)LKV
    VKK)6S5
    5KB)C1N
    KKP)S2T
    PVJ)3HW
    9VF)2PX
    QP2)2S5
    R7B)6ZW
    TSZ)ZMC
    THF)Q8K
    NXH)3WL
    N11)SHQ
    141)NQX
    4KF)NNC
    7KC)2QV
    Z9R)6YP
    5BX)P5P
    2ZB)PSW
    RF4)NQN
    L7P)9Q2
    2QV)P2K
    FBQ)LCB
    X8S)FWT
    PKC)2L9
    QH1)7WZ
    CP9)DJ2
    TWR)RYQ
    QBH)YN3
    JH2)W8Z
    Q7J)6N5
    QC6)LNQ
    WHX)2HK
    S6P)FGT
    8K5)VNP
    MJS)32J
    1LG)YQZ
    NG2)T3B
    ZC9)CPW
    ZQT)7JM
    LLS)ND7
    VP3)9NR
    8T9)6SZ
    DJJ)B52
    MDN)V74
    N9F)VFW
    G9F)SQY
    N75)S62
    9KF)5J3
    RYQ)VMY
    QMS)YZM
    7KW)2YH
    7NS)R64
    1R7)Y94
    PYR)J9Z
    NW5)2MG
    BTM)QBH
    P7N)JFQ
    P71)5V4
    QL2)HBD
    X57)X5R
    P2C)3D2
    KL9)6DR
    6YP)KZ8
    886)3DG
    NPZ)QJV
    8QW)TVB
    XFF)J53
    PKF)5X6
    SCY)27Z
    GD9)W6M
    FLB)7KC
    DTS)CMR
    K5R)BJW
    JGN)XCG
    M1K)BDF
    VZJ)GQ7
    HPB)T35
    J3R)9G6
    H11)VP3
    6B3)NQ5
    KPD)DXH
    RKW)8WP
    S9T)5D3
    6G4)4D8
    9K2)V2Z
    CYC)B99
    C6X)1MR
    1F4)YK3
    B2R)J2C
    YK1)QZP
    9J1)7T1
    2PK)R16
    ZZ9)MP4
    D3H)3FH
    FBP)XGL
    BW5)YZK
    VXF)MY5
    R5C)T8F
    ZFM)8JH
    VH7)2PY
    LYB)ZR7
    5SK)716
    V8S)GYQ
    4HW)VCB
    LJQ)YG5
    69S)Q2L
    KCT)YSM
    VN6)DJM
    MFL)Q6M
    HTR)VM5
    CVG)7KW
    VMY)B11
    ZF1)QF5
    MKB)Z9R
    HZG)G28
    T2F)NV1
    BT5)B7K
    7NF)3LR
    MPT)YPN
    KJS)KND
    8B9)Q3N
    TNT)5ZG
    Z47)TMS
    PSM)WDM
    91R)MDF
    WDF)3VR
    WYX)CFG
    7SV)4KN
    B5Z)4XZ
    VRM)FFM
    N75)B2R
    HW6)K8P
    RX4)2P7
    B1K)R8P
    5J3)LYB
    FQV)KZJ
    HQY)4MC
    SY6)911
    CQ3)M5Y
    S3C)HDX
    6PD)5R3
    C3C)PYH
    QZR)KX8
    MXW)BLP
    51J)Z5C
    Q9X)1TH
    FT1)LFR
    FRX)NXH
    3WM)6MG
    Z44)J3C
    CKN)43Z
    Q3H)32N
    59T)THR
    7KQ)CLR
    85Y)BC8
    WRK)W7N
    WN7)VQ2
    HDX)X7H
    FGD)J68
    P18)CHN
    YKV)2JH
    VML)JXT
    J7M)C8K
    K1N)LNS
    C14)3L9
    1C3)YMT
    5C9)5LB
    X9N)X7R
    2M5)X47
    92C)DRM
    QV3)PPM
    8VF)LW9
    8B1)LK6
    BTB)Y25
    8YL)Z3X
    235)BH2
    GQ7)2YL
    4ZK)KBF
    JCD)S3C
    5VR)6GJ
    3YR)97K
    6KX)VWH
    4DW)39F
    7QX)D7Q
    GJ5)V8S
    3LB)T5M
    T8F)THF
    YPL)SSZ
    BSS)7QX
    99R)V54
    CY8)TM1
    M9D)MC7
    ZM3)J3R
    RXS)T5N
    WDF)CCX
    RBW)9JB
    XL1)GL8
    CV4)69S
    5FG)ZBK
    XJS)8PW
    9ZD)1X8
    L1J)2RM
    F5K)YKG
    6SN)WY8
    X7Z)DT5
    YN3)3M4
    RJS)JJB
    COM)3TD
    3FH)M4L
    6C3)9Q3
    7DD)SJX
    KND)XZZ
    82G)HW6
    PLW)XPH
    XGL)S18
    XBK)QX7
    3HN)DC6
    NG5)PND
    RF9)KQF
    6WL)MTF
    R9Q)HPB
    K1Y)L9W
    TSZ)NGS
    18N)X2G
    7FT)CXH
    CJS)6M4
    1NH)Q4D
    CLR)R2S
    Z84)F85
    RDJ)T1L
    NNC)YGF
    CGP)68C
    1MG)K1Z
    L9Z)D2G
    69Q)HJV
    Y25)7JD
    HQL)94F
    2M8)NBL
    W1L)C68
    BC8)P6H
    BXJ)RXS
    9NR)PB5
    LFY)FDS
    NTL)NPZ
    BH2)4HW
    4KP)FN7
    V1H)4H9
    21Q)B4Z
    5GJ)PLW
    59T)WTF
    3VJ)8VW
    H1G)4KF
    TZY)RJS
    PSW)164
    VML)TKZ
    RFK)MZ7
    CQF)1C8
    DJM)5LX
    18N)88M
    LXJ)N8G
    8HG)ML9
    XD7)QJT
    5G3)326
    Y3Z)KSZ
    N5G)45D
    RLW)FW2
    SVQ)121
    5Z3)LDY
    SXC)HQL
    FYX)XKZ
    T84)2MX
    Q8K)BDB
    7PX)PC2
    GYQ)2M8
    LNS)F3N
    H5B)ZTJ
    1XD)N96
    GJC)PYQ
    7TQ)4L8
    6G1)ZF9
    6SZ)CP9
    JS1)4KC
    FY1)3W1
    PKW)1F4
    8NG)5XW
    JG4)K4B
    43W)QPB
    8N9)SRD
    B99)9ZD
    VNZ)N76
    MX4)51J
    1T1)BC3
    CWQ)BSS
    MP4)KPD
    WLB)9M5
    PG1)Z5V
    Z6V)222
    F7S)M93
    YBR)GJC
    233)FLG
    VNW)8CV
    BPP)XGJ
    T5M)NCL
    YMJ)4FB
    GJ6)WMD
    48K)DNH
    92X)THL
    L34)MNJ
    3M4)ZBC
    R5L)JRM
    DQ5)4RS
    YY2)2JY
    MWY)GG8
    66R)1TS
    65K)BHM
    LTH)GQG
    FKS)PCF
    L2Y)8MK
    D6J)LCW
    QC8)4NZ
    GL4)D3H
    J1S)QH1
    F85)PB2
    4GF)7FT
    JW2)9GJ
    CS1)FPJ
    FQQ)MCP
    2BL)GK5
    BPF)SBL
    124)4GV
    TVZ)1LZ
    2YQ)FBQ
    VV8)2ZR
    4KN)TVZ
    57F)NTJ
    2JH)7SV
    L76)7L8
    DC6)3XV
    2PY)M42
    LY4)DYQ
    8BF)51P
    CB2)7V2
    4FS)8NG
    PPR)P18
    157)YZ4
    HSJ)5HY
    5LV)YXR
    BKS)XNT
    GQB)NCH
    JNC)TLP
    KKT)FWX
    GCR)V6G
    X58)Z6J
    LCB)3YR
    NTJ)NSC
    326)79Y
    PKR)MVQ
    WRK)Y46
    14Y)95D
    911)DG3
    2ZR)J4V
    94W)3WM
    RP2)5GJ
    14R)6SN
    BN9)F1R
    ZWG)XR5
    J3D)5TG
    31W)YY2
    5SK)VJT
    5K6)ZFM
    FH5)DRK
    WPX)G5Q
    5B2)FKH
    5X6)57F
    DWT)YPL
    3FV)6GW
    CS2)MX4
    NG5)636
    N7K)BCL
    LDD)XY8
    Y1P)DHF
    7PT)4L3
    X7H)WRB
    BLP)74X
    MCP)4DN
    7S7)FLL
    RF2)8W4
    J8X)GYR
    5SG)N75
    BSQ)7Y9
    935)VRM
    GZC)V1H
    NCH)ZY8
    681)4J1
    YGF)PLX
    RGS)HBQ
    NQ5)JM1
    PJL)X25
    Q15)XXN
    T3S)H11
    KGK)MDN
    CMR)PTH
    HGM)3Z8
    5HG)MCT
    4GF)6LQ
    V2B)L2Y
    935)V3C
    M42)CJS
    S4M)9YS
    RB4)ZL2
    CS5)ZLJ
    RB2)CPS
    CYR)NCY
    FLL)YBW
    L7S)PVZ
    PB2)LPX
    4YM)Z5G
    32N)FLB
    ZVQ)D32
    3W1)W7G
    BYL)DRT
    YMT)WQP
    NQN)2V8
    68C)NPD
    6N5)G9F
    J8H)NJV
    FZB)V9M
    KLF)PJL
    GXV)YL7
    VJT)DKZ
    7PX)358
    SCW)F8D
    SQY)F9V
    FKH)2BL
    5ZD)85Y
    VX5)PBZ
    W3Q)TD2
    2XF)CQG
    3BG)8X2
    ZC1)PFK
    PLH)FCF
    42C)M73
    S95)LJQ
    1C8)WTV
    1MQ)PWR
    F9C)X9J
    NPD)K5S
    HSG)FZT
    HDX)G76
    PSG)M8Y
    N76)NZ7
    M2G)3DB
    3K4)C14
    TCW)K1Y
    XX4)7TW
    FLG)3FD
    LZ6)SQJ
    45K)XRN
    THR)ZKG
    ZH2)N6N
    K8C)5JT
    M5Y)JYQ
    9J8)MFL
    KYY)ZM2
    WL8)RG1
    K6T)2CK
    WB4)HY8
    WW9)X91
    XNT)H6Z
    JQ6)3FV
    VRL)5CC
    R74)8L3
    51T)ZYJ
    7QT)71X
    5N4)WWB
    6B3)YB6
    KN6)CV3
    HMG)5SG
    312)HCP
    PBZ)22C
    1SP)MYD
    V54)91P
    Q4D)FBP
    86G)G1T
    KX8)7X3
    C97)8WD
    D1D)1Q4
    RF1)KJS
    VPH)CKN
    5KT)JN3
    2XF)K1N
    ZWR)RB4
    N1S)G6J
    NQ1)3S9
    Q8W)KCT
    B8T)NYF
    74X)9SJ
    JM1)FJZ
    VCB)Q7J
    1VL)QSC
    X2G)VNZ
    XNF)3PN
    VX8)HRJ
    PSG)423
    PL7)Q87
    KX3)78K
    QM1)454
    QFC)VZJ
    RK6)4VM
    M8B)Q9X
    7G8)CS7
    QSM)M6F
    GJ5)KKT
    WVK)ZWG
    HSG)FZB
    91R)RBX
    MW6)5Z7
    QJV)X1N
    XWY)J6M
    PY8)SPR
    JW8)233
    9MS)Y1P
    WY8)77T
    PL8)H5B
    98X)NV4
    PYQ)NRM
    PCF)R74
    HQL)WLJ
    W3Y)1MQ
    PST)3VJ
    DBZ)LTH
    GNF)VL9
    QRG)VML
    S67)8YL
    P5P)35K
    QC6)VTX
    ZKR)X9N
    CPS)S35
    WZ2)SCY
    Z2R)T1Z
    G36)C84
    G1T)3JH
    YG5)1V3
    R22)TG6
    YL7)FMV
    X47)5YM
    32K)28K
    6GW)1XD
    W3Q)ZGS
    W1Y)DQ5
    X7N)9WR
    3Z8)YYQ
    JQ2)9J8
    VKX)58Z
    92B)124
    JPB)JSQ
    DRV)1S5
    NCH)M38
    D32)JPB
    VL9)L98
    QHW)LZ6
    CXH)DRV
    X1N)6VV
    6NQ)7GN
    SWP)L5P
    3Z8)DWT
    W8Z)L9Z
    9KS)XBC
    1F4)92C
    SQJ)WLS
    JYQ)LLG
    2B2)QC8
    G6J)DPQ
    W7G)ZHK
    FG5)W9X
    RX4)9VF
    518)K79
    MY5)T6T
    NGS)6PD
    GVY)B7Q
    SGW)S2V
    B8R)CFH
    NSM)L4M
    LYX)8MF
    6WL)4KP
    SQD)L7P
    77L)8N3
    X8F)TP8
    23N)BK7
    92Y)RK6
    3VT)TC9
    YJQ)WYX
    5R3)WZ2
    MVQ)CQF
    CFG)VJD
    Z54)CJZ
    11P)32K
    Y7G)QSM
    QKN)SAN
    WRB)6D6
    FCF)SZZ
    Q6N)BDD
    ZNM)QM1
    GVY)982
    NDH)G1S
    45D)66G
    SSZ)PG1
    D7Q)TSZ
    3X7)91R
    59X)BYL
    28K)5D1
    VTB)5SK
    38C)SXG
    TJK)DD5
    Q8N)FRX
    48F)RJH
    LNQ)RBW
    XFX)D6J
    3VR)J9J
    D32)S5D
    DN1)DTS
    YPN)WW5
    TP8)BD7
    5YS)8XG
    C8K)QV9
    6LQ)M1K
    1PB)6RM
    8VB)PKT
    78N)82G
    JJB)KLF
    T5Q)33S
    CHN)VQ1
    N5G)9J1
    MY1)8HY
    3NP)XH2
    K4B)C98
    L4M)WYP
    J8H)2PK
    G2Z)SWC
    W5C)V5W
    RG1)6G4
    JRM)3LS
    4FB)F31
    LDY)XNF
    CTK)VRL
    29X)FK3
    95T)L81
    LYT)YFG
    T69)FBV
    BKB)K3C
    4MC)13N
    CS7)BTM
    1VV)WL8
    8MK)FLT
    HW6)TKD
    KXT)RX4
    T32)DN1
    ZHT)Q9L
    NDN)5Z3
    G6B)F7D
    VF1)DJJ
    2DY)CVG
    Q2L)6NQ
    F65)NVY
    7J1)Z9C
    NJV)VNT
    4R7)81Y
    3WF)2GH
    TWQ)8VF
    TGF)Q49
    N1X)312
    4KF)SC5
    XY8)48F
    W7Y)8K5
    25Y)PLH
    ZM2)157
    X7R)QZR
    3LS)VLW
    8BF)JCD
    L2Y)XWD
    R6P)8N9
    66S)T69
    7JD)PPR
    6K8)YRK
    2YH)MPT
    5LB)T7X
    YFG)1MG
    DXH)JGN
    4JN)GCC
    3XV)R5C
    NRY)CYC
    CCX)FYX
    1LZ)NDN
    FN7)RLW
    V3C)MC6
    VDP)TCH
    9XS)MQ2
    P93)BSX
    B5T)KVP
    9Y2)5C9
    GCT)3K4
    56N)DYD
    35T)X8Z
    L9N)55T
    6M4)G3N
    VJJ)ZC9
    KVD)P7N
    R16)HZG
    DG3)S95
    LKH)BD2
    777)S28
    3VJ)2LN
    S4B)D3J
    GCC)F7P
    1V3)XD7
    31K)QF8
    JTP)21F
    C68)JS1
    H4Z)JTZ
    DPQ)1LG
    33S)QP2
    ZL2)XTN
    ZW5)HHV
    6RM)KFG
    V6G)65Z
    L1J)2M5
    85W)LDS
    V9M)WT8
    ZZF)T1F
    G5T)22R
    S18)L3M
    792)HK3
    KDQ)45K
    C3N)DBZ
    CQG)1V5
    TRH)M8X
    FW2)J8X
    GG8)8CM
    MZ7)H4Z
    JXT)H8C
    MQ2)2B2
    C61)XJ8
    LDD)GT8
    QPB)4R7
    4VM)67X
    KY1)Q8N
    GL8)2C5
    TWQ)946
    PY4)669
    ZMC)RCT
    QMV)JQ2
    JHS)R22
    5CC)GTK
    LWB)G9N
    11B)6VM
    WTF)VNW
    6GJ)1C3
    Z9C)6B7
    YQZ)99R
    FMV)RN2
    KVP)2TP
    TVB)31W
    NCY)3BG
    S28)PST
    BDB)CD7
    4KC)GD9
    BC3)TT5
    Z5C)KY1
    ZDB)86G
    ZR7)6ZZ
    KHP)XWY
    SNW)ZDB
    G9N)ZH2
    WLJ)WYJ
    7GN)CB2
    LLG)6VH
    2RM)MN3
    1MZ)Q3H
    MN3)QMS
    3SV)3NP
    GP7)BTB
    F4N)74W
    YLZ)64V
    2CK)1KT
    6S5)5FG
    ZM8)3T4
    HJX)J8H
    4PL)1NH
    B7K)56N
    4L8)338
    1K5)SNW
    3WL)C6X
    ND7)FQV
    D2Q)47G
    JW8)M4Y
    LDS)F83
    4S1)4C2
    124)CGG
    FK3)SVQ
    H1G)YX6
    LSL)P71
    W2D)FG5
    HJV)WN7
    HF4)TGF
    QWW)GL4
    SNK)1PB
    QF5)BSQ
    GL5)QL2
    F9M)VGS
    DJF)C9L
    9SJ)S4M
    854)CS2
    S5D)MXW
    GCR)JQ6
    BHM)WDP
    N8G)T1N
    5TG)ZVQ
    MKB)Z6V
    D4Y)7S7
    QTY)KDR
    4C2)1K5
    8ZH)MF5
    8PB)DVG
    5D1)7KQ
    8WP)W5C
    P2K)VJJ
    7T1)XL1
    WN7)SXC
    GXV)JNC
    HHV)N1S
    5LX)777
    XKV)D8N
    HCP)1SP
    Y5D)TPF
    8CM)7NF
    VNS)VX8
    RRH)LFL
    HS2)Z47
    JTZ)MWY
    XK4)QC3
    R8P)1T1
    NBL)CZ9
    ZGQ)SV7
    2GP)VPH
    6GN)MNR
    XCG)H5S
    XZZ)CY8
    BMQ)YKV
    Q6M)66S
    ZTJ)3YZ
    4SH)8T9
    QP2)BML
    Q87)LSL
    75X)RF2
    6DR)6TR
    946)P2C
    RTC)ZW5
    M4Y)FX4
    QX7)14R
    H6Z)PQR
    SV7)JG4
    6L8)ZZF
    SHQ)MX2
    JSQ)7PT
    81Y)6GN
    C9L)GCT
    N6N)7DD
    CVV)Y3Y
    8HY)R2R
    S2V)WRK
    KFR)9KF
    5V4)886
    TMS)7LY
    D67)8T5
    32J)SZ6
    LFR)HGM
    CYZ)GZB
    LY1)DXN
    WDM)D4Y
    HK3)5LM
    1KT)7FD
    ZHK)ZF1
    YKG)SNC
    WYJ)SGW
    JN3)KYY
    5C9)T84
    LW8)XBK
    5ZG)QYV
    PYT)292
    CSL)95T
    WQP)43W
    5D3)6WL
    X3T)K89
    WTV)QC6
    WTT)B3Z
    M8X)8B1
    154)ZNM
    788)NTX
    GL5)CYR
    7Y9)F9M
    BML)9K2
    T7X)LW8
    GR6)7LJ
    DX3)QYQ
    3WL)PKC
    8T5)TRT
    F3N)J1S
    ZGS)NY1
    HXF)BKB
    X7Y)7TQ
    DT5)R2V
    P6H)5N4
    J9J)5VR
    KYY)JK4
    4J1)YBS
    VGS)2LW
    RN2)VKX
    2D8)QFC
    YL7)59T
    XGJ)NVV
    L8J)NDH
    WW5)4ZK
    """
  end
end
