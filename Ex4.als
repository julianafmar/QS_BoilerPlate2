open Ex3
open util/ordering[Id]

sig Id { }

sig ONode extends Node { 
    id : one Id
}

sig OHeadNode extends HeadNode {
}

// list has to be ordered
/*fact {
    all n1, n2 : ONode | 
        n1.next = n2 && n1 != n2 implies n1.id.lte[n2.id]
}*/

// all ids are unique
fact {
  always all n1, n2 : ONode | 
    n1 != n2 implies n1.id != n2.id 
}

// list has to be ordered
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

pred OInsertMiddle[hn : OHeadNode, n : ONode] {
    //pre-condition:
    hn.frst != none and hn.lst != none
    hn.frst.id.gt[n.id] and n.id.lt[hn.lst.id]
    //post-condition:
    n.nprev' = FindNode[hn.frst.nnext, n]
    n.nnext' = FindNode[hn.frst.nnext, n].nnext
    FindNode[hn.frst.nnext, n].nnext' = n
    FindNode[hn.frst.nnext, n].nnext.nprev' = n
    /*Middle[hn.frst.nnext, n]
    all n1, n2 : ONode | 
        n1 != n2 implies Middle[n1, n2]*/
    nnext' = nnext - (FindNode[hn.frst.nnext, n] -> FindNode[hn.frst.nnext, n].nnext) + (FindNode[hn.frst.nnext, n] -> n) + (n -> FindNode[hn.frst.nnext, n].nnext)
    nprev' = nprev - (FindNode[hn.frst.nnext, n].nnext -> FindNode[hn.frst.nnext, n]) + (FindNode[hn.frst.nnext, n].nnext -> n) + (n -> FindNode[hn.frst.nnext, n])
    //frame-condition:
    frst' = frst
    lst' = lst
}

fun FindNode[n1 : ONode, n2 : ONode] : ONode {
    n1.id.gt[n2.id] implies FindNode[n1, n2.nnext] else n2
}

pred Middle[n1 : ONode, n2 : ONode] {
    SmallerMiddle[n1, n2] or GreaterMiddle[n1, n2]
}

pred SmallerMiddle[n1 : ONode, n2 : ONode] {
    //pre-conditions:
    n1.id.lt[n2.id]
    //post-conditions:
    n2.nprev.nnext' = n1
    n1.nprev' = n2.nprev
    n1.nnext' = n2
    n2.nprev' = n1
    nprev' = nprev - (n2 -> n2.nprev) + (n2 -> n1) + (n1 -> n2.nprev)
    nnext' = nnext - (n2.nprev -> n2) + (n2.nprev -> n1) + (n1 -> n2)
    //frame-condictions:
    frst' = frst
    lst' = lst
}

pred GreaterMiddle[n1 : ONode, n2 : ONode] {
    //pre-conditions:
    n1.id.gt[n2.id]
    //post-conditions:
    Middle[n2.nnext, n1]
    //frame-conditions:
    frst' = frst
    lst' = lst
}

run { } for 2 HeadNode, 5 Node, exactly 2 OHeadNode, exactly 5 ONode, 5 Id