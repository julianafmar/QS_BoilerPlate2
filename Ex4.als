open Ex3
open util/ordering[Id]

sig Id { }

sig ONode extends Node { 
    id : one Id
}

sig OHeadNode extends HeadNode { }

// list has to be ordered
/*fact {
    all n1, n2 : ONode | 
        n1.next = n2 && n1 != n2 implies n1.id.lte[n2.id]
}*/

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

pred OInsert[hn : OHeadNode, n : ONode] {
    OInsertFirst[hn, n] or OInsertLast[hn, n] or OInsertMiddle[hn, n] or OInsertEmpty[hn, n]
}

pred OInsertFirst[hn : OHeadNode, n : ONode] {
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

pred OInsertLast[hn : OHeadNode, n : ONode] {
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

pred OInsertEmpty[hn : OHeadNode, n : ONode] {
    //pre-conditions:
    hn.frst = none and hn.lst = none
    //post-conditions:
    hn.frst' = n
    hn.lst' = n
    //frame-conditions:
    nnext' = nnext
    nprev' = nprev
}

pred OInsertMiddle[hn : HeadNode, n : ONode] {
    //pre-condition:
    hn.frst != none and hn.lst != none
    hn.frst.id.gt[n.id] and n.id.lt[hn.lst.id]
    //post-condition:
    all n1 : ONode |
        n1.id.lte[n.id] && n1.nnext.id.gte[n.id] implies n1.nnext' = n and 
                                            n1.nnext.nprev' = n and 
                                            n.nnext' = n1.nnext and
                                            n.nprev' = n1
    //frame-condition:
    frst' = frst
    lst' = lst
}

run { eventually some n : ONode, h : OHeadNode | OInsert[h, n] } for 3 HeadNode, 5 Node, exactly 2 OHeadNode, exactly 4 ONode, 4 Id