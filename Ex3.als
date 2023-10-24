module Ex3

sig Node { 
    var nprev: lone Node,
    var nnext: lone Node
}

sig HeadNode {
    var frst: lone Node,
    var lst: lone Node
}

// The first node doesn't have a previous node and the last node doesn't have a next node
fact C1 {
    always(no(frst.nprev)) and always(no(lst.nnext))
}

// If a node n has a previous node, then the previous node has a next node that's n. The same goes for next nodes.
fact C2 {
    always(nprev = ~nnext)
}

// nprev and nnext are acyclic
fact C3 {
    always(no(^nprev & iden)) and always(no(^nnext & iden))
}

// if a list has more than 0 nodes it should have lst and frst
fact C4 {
    all n : Node |
        n.nnext != none => always(one(n.*nnext.~lst))
}

// every node can only be in exactly one list
fact C5 {
    all n : Node |
        n.nnext != none => always(one(n.*nprev.~frst))
}

// the first node is connected to the last of its list
fact C6 {
    all hn : HeadNode |
        always(hn.frst.*nnext.~lst = hn)
}

fact C7 {
    all hn : HeadNode |
        always(hn.lst.*nprev.~frst = hn)
}

pred insert[n:Node, hn:HeadNode] {
    insert_none[n, hn] or insert_nodes[n, hn]
}

pred insert_none[n:Node, hn:HeadNode] {
    //pre-condition: 
    hn.frst = none
    hn.lst = none
    n.*nprev.~frst = none
    //post-condition:
    hn.frst' = n
    hn.lst' = n
    //frame-condition:
    nnext' = nnext
}

pred insert_nodes[n : Node, hn : HeadNode] {
    //pre-condition:
    hn.frst != none 
    hn.lst != none
    n.*nprev.~frst = none
    //post-conditions:
    n.nprev' = hn.lst
    hn.lst.nnext' = n
    hn.lst' = n
    nnext' = nnext + (hn.lst -> n)
    nprev' = nprev + (n -> hn.lst)
    //frame-conditions:
    frst' = frst
}

pred remove[n : Node, hn : HeadNode] {
    remove_only_element[n, hn] or remove_first[n, hn] or remove_last[n, hn] or remove_nodes[n, hn]
}

pred remove_only_element[n : Node, hn : HeadNode] {
    //pre-conditions:
    hn.lst != none and hn.frst != none
    hn.lst = hn.frst
    n = hn.frst
    //post-condition:
    hn.lst' = none
    hn.frst' = none
    //frame-conditions:
    nnext' = nnext
    nprev' = nprev
}

pred remove_first[n : Node, hn : HeadNode] {
    //pre-conditions:
    hn.frst != none and hn.lst != none
    hn.frst != hn.lst
    n = hn.frst
    //post-conditions:
    hn.frst' = hn.frst.nnext
    hn.frst.nnext.nprev' = none
    nnext' = nnext - (hn.frst -> hn.frst.nnext)
    nprev' = nprev - (hn.frst.nnext -> hn.frst)
    //frame_conditions:
    lst' = lst
}

pred remove_last[n : Node, hn : HeadNode] {
    //pre-conditions:
    hn.frst != none and hn.lst != none
    hn.frst != hn.lst
    n = hn.lst
    //post-conditions:
    hn.lst' = hn.lst.nprev
    hn.lst.nprev.nnext' = none
    nnext' = nnext - (hn.lst.nprev -> hn.lst)
    nprev' = nprev - (hn.lst -> hn.lst.nprev)
    //frame_conditions:
    frst' = frst    
}

pred remove_nodes[n : Node, hn : HeadNode] {
    //pre-conditions:
    hn.frst != none and hn.lst != none
    hn.frst != hn.lst
    n in hn.frst.*(nnext)
    //post-conditions:
    n.nprev.nnext' = n.nnext
    n.nnext.nprev' = n.nprev
    nnext' = nnext - (n.nprev -> n) - (n -> n.nnext) + (n.nprev -> n.nnext)
    nprev' = nprev - (n.nnext -> n) - (n -> n.nprev) + (n.nnext -> n.nprev)
    //frame_conditions:
    frst' = frst
    lst' = lst
}

run { eventually some n : Node, h : HeadNode | insert[n, h] } for exactly 2 HeadNode, exactly 5 Node







/*
3.1
- nodes can't be linked to themselves
- nodes can either be free single dll
- specify the invariants of facts with always
- fact {always inv}
...

3.3
- insert -> whatever you want

*/








/*
Coisas
if a list has more than 0 nodes it should have lst and frst
when it has only one node make sure its the first and last
*/

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