module Ex3

sig Node { 
    var nprev: lone Node,
    var nnext: lone Node
}

sig HeadNode {
    var frst: lone Node,
    var lst: lone Node
}

// The first node doesn't have a previous node
fact C1 {
    always(no(frst.nprev))
}

// The last node doesn't have a next node
fact C2 {
    always(no(lst.nnext))
}

// If a node n has a previous node, then the previous node has a next node that's n. The same goes for next nodes.
fact C3 {
    always(nprev = ~nnext)
}

// nprev is not acyclic
fact C4 {
    always(no(^nprev & iden))
}

// nnext is not acyclic
fact C5 {
    always(no(^nnext & iden))
}

// Every node can only be in exactly one list (be connected to one HeadNode)
fact C6 {
    all n : Node |
        always(n.nnext != none or n.nprev != none => one(n.*nprev.~frst))
}

// A frst Node cannot be connected to more than one HeadNode
fact C7 {
    all hn : HeadNode |
        always(hn.frst != none => one(hn.frst.*nprev.~frst))
}

// The first node is connected to the last of its list
fact C8 {
    all hn : HeadNode |
        always(hn.frst != none => hn.frst.*nnext.~lst = hn)
}

// If a HeadNode has a first node, then it has a last node. The same goes for last nodes.
fact C9 {
    all hn : HeadNode |
        always(one(hn.frst) => one(hn.lst) or one(hn.lst) => one(hn.frst))
}

// The number of lasts is equal to the number of lasts
fact C11 {
    always #frst = #lst
}

pred insert[n : Node, hn : HeadNode] {
    insertNone[n, hn] or insertNodes[n, hn]
}

pred insertNone[n : Node, hn : HeadNode] {
    // pre-condition: 
    hn.frst = none
    hn.lst = none
    n.*nprev.~frst = none
    // post-condition:
    hn.frst' = n
    hn.lst' = n
    // frame-condition:
    nnext' = nnext
    nprev' = nprev
}

pred insertNodes[n : Node, hn : HeadNode] {
    // pre-condition:
    hn.frst != none 
    hn.lst != none
    n.*nprev.~frst = none
    // post-conditions:
    n.nprev' = hn.lst
    hn.lst.nnext' = n
    hn.lst' = n
    nnext' = nnext + (hn.lst -> n)
    nprev' = nprev + (n -> hn.lst)
    // frame-conditions:
    frst' = frst
}

pred remove[n : Node, hn : HeadNode] {
    removeOnlyElement[n, hn] or removeFirst[n, hn] or removeLast[n, hn] or removeNodes[n, hn]
}

pred removeOnlyElement[n : Node, hn : HeadNode] {
    // pre-conditions:
    hn.lst != none and hn.frst != none
    hn.lst = hn.frst
    n = hn.frst
    // post-condition:
    lst' = lst - (hn -> n)
    frst' = frst - (hn -> n)
    // frame-conditions:
    nnext' = nnext
    nprev' = nprev
}

pred removeFirst[n : Node, hn : HeadNode] {
    // pre-conditions:
    hn.frst != none and hn.lst != none
    hn.frst != hn.lst
    n = hn.frst
    // post-conditions:
    hn.frst' = hn.frst.nnext
    hn.frst.nnext.nprev' = none
    nnext' = nnext - (hn.frst -> hn.frst.nnext)
    nprev' = nprev - (hn.frst.nnext -> hn.frst)
    // frame_conditions:
    lst' = lst
}

pred removeLast[n : Node, hn : HeadNode] {
    // pre-conditions:
    hn.frst != none and hn.lst != none
    hn.frst != hn.lst
    n = hn.lst
    // post-conditions:
    hn.lst' = hn.lst.nprev
    hn.lst.nprev.nnext' = none
    nprev' = nprev - (hn.lst -> hn.lst.nprev)
    nnext' = nnext - (hn.lst.nprev -> hn.lst)
    // frame_conditions:
    frst' = frst    
}

pred removeNodes[n : Node, hn : HeadNode] {
    // pre-conditions:
    hn.frst != none and hn.lst != none
    hn.frst != hn.lst
    n in hn.frst.*(nnext)
    // post-conditions:
    n.nprev.nnext' = n.nnext
    n.nnext.nprev' = n.nprev
    nnext' = nnext - (n.nprev -> n) - (n -> n.nnext) + (n.nprev -> n.nnext)
    nprev' = nprev - (n.nnext -> n) - (n -> n.nprev) + (n.nnext -> n.nprev)
    // frame_conditions:
    frst' = frst
    lst' = lst
}

// 3.2
run { } for exactly 2 HeadNode, exactly 5 Node

// 3.4
run { eventually some n : Node, h : HeadNode | insert[n, h] } for exactly 2 HeadNode, exactly 5 Node
run { eventually some n : Node, h : HeadNode | remove[n, h] } for exactly 2 HeadNode, exactly 5 Node