open Ex3
open util/ordering[Id]

sig Id { }

sig ONode extends Node { 
    id : one Id
}

sig OHeadNode extends HeadNode { }

// All ids are unique
fact {
  always all n1, n2 : ONode | 
    n1 != n2 implies n1.id != n2.id 
}

// List has to be ordered
fact {
    always all n1, n2 : ONode |
        n2 in n1.*(nnext) and n2 != n1 implies n1.id.lte[n2.id]
}

// OHeadNode should only be connected to ONodes
fact {
    always all hn : OHeadNode, n : Node |
        n in hn.frst.*(nnext) implies n in ONode
}

pred OInsert[n : ONode, hn : OHeadNode] {
    OInsertFirst[n, hn] or OInsertLast[n, hn] or OInsertMiddle[n, hn] or OInsertEmpty[n, hn]
}

pred OInsertFirst[n : ONode, hn : OHeadNode] {
    //pre-condition: 
    hn.frst != none and hn.lst != none
    n.id.lte[hn.frst.id]
    //post-condition:
    n.nnext' = hn.frst
    hn.frst.nprev' = n
    hn.frst' = n
    nnext' = nnext + (n -> hn.frst)
    nprev' = nprev + (hn.frst -> n)
    //frame-condition:
    lst' = lst
}

pred OInsertLast[n : ONode, hn : OHeadNode] {
    //pre-condition:
    hn.frst != none and hn.lst != none
    hn.lst.id.lte[n.id]
    //post-condition:
    n.nprev' = hn.lst
    hn.lst.nnext' = n
    hn.lst' = n
    nprev' = nprev + (n -> hn.lst)
    nnext' = nnext + (hn.lst -> n)
    //frame-condition:
    frst' = frst
}

pred OInsertEmpty[n : ONode, hn : OHeadNode] {
    //pre-conditions:
    hn.frst = none and hn.lst = none
    //post-conditions:
    lst' = lst + (hn -> n)
    frst' = frst + (hn -> n)
    //frame-conditions:
    nnext' = nnext
    nprev' = nprev
}

pred OInsertMiddle[n : ONode, hn : OHeadNode] {
    //pre-condition:
    hn.frst != none and hn.lst != none
    hn.frst.id.lt[n.id] and hn.lst.id.gt[n.id]
    //post-condition:
    all n1 : ONode |
        n1.id = max[prevs[n.id] & hn.frst.*nnext.id] => 
            nprev' = nprev - (n1.nnext -> n1) + (n -> n1) + (n1.nnext -> n) and
            nnext' = nnext - (n1 -> n1.nnext) + (n1 -> n) + (n -> n1.nnext)
    //frame-condition:
    frst' = frst
    lst' = lst
}

// 4.2
run { } for 3 HeadNode, 5 Node, exactly 2 OHeadNode, exactly 5 ONode, 5 Id

// 4.4
run { eventually some n : ONode, h : OHeadNode | OInsert[n, h] } for 3 HeadNode, 5 Node, exactly 2 OHeadNode, exactly 5 ONode, 5 Id
run { eventually some n : ONode, h : OHeadNode | remove[n, h] } for 3 HeadNode, 5 Node, exactly 2 OHeadNode, exactly 5 ONode, 5 Id