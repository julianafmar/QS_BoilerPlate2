sig Node { 
    nprev: lone Node,
    nnext: lone Node
}

sig HeadNode {
    frst: one Node,
    lst: one Node
}

// The first node doesn't have a previous node and the last node doesn't have a next node
fact {
    no (frst.nprev) 
    no (lst.nnext)
}

// If a node n has a previous node, then the previous node has a next node that's n. The same goes for next nodes.
fact {
    nprev = ~nnext
}

// nprev and nnext are acyclic
fact {
    no (^nprev & iden)
    no (^nnext & iden)
}

// every node that's not the first node has a previous node and every node that's not the last node has a next node
fact {
    // tem de se usar ^
    /*^nprev = Node - frst
    ^nnext = Node - lst*/    
    all n: Node, h: HeadNode |
        n != h.frst && n != h.lst => one(n.nprev) && one(n.nnext)
}

pred insert[n:Node, hn:HeadNode] {
    // nao ha problema se um deles for none?
    hn.lst.nnext = n
    n.nprev = hn.lst
    hn.lst = n
}

pred remove[n:Node, hn:HeadNode] {
    // nao ha problema se um deles for none?
    n = hn.frst => hn.frst = n.nnext
    n = hn.lst => hn.lst = n.nprev
    n.nprev.nnext = n.nnext
    n.nnext.nprev = n.nprev
}

run { } for exactly 5 Node, exactly 2 HeadNode 