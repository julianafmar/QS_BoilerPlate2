sig Node { 
    nprev: lone Node,
    nnext: lone Node
}

sig HeadNode {
    frst: lone Node,
    lst: lone Node
}

// The first node doesn't have a previous node and the last node doesn't have a next node
fact C1 {
    no(frst.nprev) and no(lst.nnext)
}

// If a node n has a previous node, then the previous node has a next node that's n. The same goes for next nodes.
fact C2 {
    nprev = ~nnext
}

// nprev and nnext are acyclic
fact C3 {
    no(^nprev & iden) and no(^nnext & iden)
}

// if a list has more than 0 nodes it should have lst and frst
fact C4 {
    one(frst) => one(lst) 
    one(lst) => one(frst)
}

// every node can only be in exactly one list
fact C5 {
    all n : Node |
        one(n.*nprev.~frst)
}

// the first node is connected to the last of its list
fact C6 {
    all hn : HeadNode |
        hn.frst.*nnext.~lst = hn
}

// every node that's not the first node has a previous node and every node that's not the last node has a next node
/*fact {
    all n: Node, h: HeadNode |
        n != h.frst implies one(n.nprev) &&
        n != h.lst implies one(n.nnext)
}*/

// every node can only be in exactly one list
/*fact C6 {
    all n : Node |
        one(firsts_reached[n]) and one(lasts_reached[n])
}
fun firsts_reached[n : Node] : set HeadNode {
    n.*nprev.~frst
}
fun lasts_reached[n : Node] : set HeadNode {
    n.*nnext.~lst
}*/

// every node can only be in exactly one list
/*fact {
    all n: Node, hn1, hn2: HeadNode |
        n in hn1.frst.*(nnext) => n !in hn2.frst.*(nnext) and
        n in hn1.lst.*(nprev) => n !in hn2.lst.*(nprev)
}*/


pred insert[n:Node, hn:HeadNode] {
    insert_first[n, hn] or insert_single_node[n, hn] or insert_nodes[n, hn]
}

pred insert_first[n:Node, hn:HeadNode] {
    //pre-condition: 
    hn.frst = none
    hn.lst = none
    //post-condition:
    hn.frst = n
    hn.lst = n
    //frame-condition:
}

pred insert_single_node[n : Node, hn : HeadNode] {
    //pre-condition:
    hn.frst != none and hn.lst != none
    hn.frst = hn.lst
    //post-conditions:
    nnext' = nnext + (hn.frst -> n)
    nprev' = nprev + (n -> hn.frst)
    hn.frst.nnext = n
    n.nprev = hn.frst
    hn.lst = n
    //frame-conditions:
}

pred insert_nodes[n : Node, hn : HeadNode] {
    //pre-conditions:
    hn.frst != none and hn.lst != none
    hn.frst != hn.lst
    //post-conditions: 
    n.nnext = hn.frst
    hn.frst = n
    hn.frst.nprev = n //n.nnext.nprev = n //
    nnext' = nnext + (n -> hn.frst) //(n -> n.nnext) //
    nprev' = nprev + (hn.frst -> n) //(n.nnext -> n) //
    //frame_conditions:
    all n1 : Node |
        n1 != n and n1 != hn.frst implies n1' = n1
}

pred remove[n : Node, hn : HeadNode] {
    // nao ha problema se um deles for none?
    /*n = hn.frst => hn.frst = n.nnext
    n = hn.lst => hn.lst = n.nprev
    n.nprev.nnext = n.nnext
    n.nnext.nprev = n.nprev*/
    remove_only_element[n, hn] or remove_first[n, hn] or remove_last[n, hn] or remove_nodes[n, hn]
}

pred remove_only_element[n : Node, hn : HeadNode] {
    //pre-conditions:
    hn.lst != none and hn.frst != none
    hn.lst = hn.frst
    n = hn.frst 
    //post-condition:
    hn.lst = none
    hn.frst = none
    nnext' = nnext - (hn.frst -> hn.lst)
    nprev' = nprev - (hn.lst -> hn.frst)
    //frame-conditions:
}

pred remove_first[n : Node, hn : HeadNode] {
    //pre-conditions:
    hn.frst != none and hn.lst != none
    hn.frst != hn.lst
    n = hn.frst
    //post-conditions:
    hn.frst.nnext.nprev = none
    hn.frst = hn.frst.nnext
    nnext' = nnext - (hn.frst -> hn.frst.nnext)
    nprev' = nprev - (hn.frst.nnext -> hn.frst)
    //frame_conditions:
    all n1 : Node |
        n1 != n and n1 != hn.frst implies n1' = n1
}

pred remove_last[n : Node, hn : HeadNode] {
    //pre-conditions:
    hn.frst != none and hn.lst != none
    hn.frst != hn.lst
    n = hn.lst
    //post-conditions:
    hn.lst.nprev.nnext = none
    hn.lst = hn.lst.nprev
    nnext' = nnext - (hn.lst.nprev -> hn.lst)
    nprev' = nprev - (hn.lst -> hn.lst.nprev)
    //frame_conditions:
    all n1 : Node |
        n1 != n and n1 != hn.frst implies n1' = n1
}

pred remove_nodes[n : Node, hn : HeadNode] {
    //pre-conditions:
    hn.frst != none and hn.lst != none
    hn.frst != hn.lst
    n in hn.frst.*(nnext)
    //post-conditions:
    n.nprev.nnext = n.nnext
    n.nnext.nprev = n.nprev
    nnext' = nnext - (n.nprev -> n) - (n -> n.nnext) + (n.nprev -> n.nnext)
    nprev' = nprev - (n.nnext -> n) - (n -> n.nprev) + (n.nnext -> n.nprev)
    //frame_conditions:
    all n1 : Node |
        n1 != n and n1 != hn.frst implies n1' = n1
}

run { eventually one n : Node, h : HeadNode | insert[n, h] } for exactly 2 HeadNode, exactly 5 Node



/*
Coisas
if a list has more than 0 nodes it should have lst and frst
when it has only one node make sure its the first and last
*/