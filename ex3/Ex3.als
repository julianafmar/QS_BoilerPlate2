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
fact { // transposta ###########################################################
    all n: Node |
        n.nprev.nnext = n
    all n: Node |
        n.nnext.nprev = n
} 
//###############################################################################

// nprev and nnext are acyclic
fact {
    /*all n: Node |
        n !in n.^nprev && n !in n.^nnext*/
    no (^nprev & iden)
}

pred insert[n:Node, hn:HeadNode] {
    hn.lst.nnext = n
    n.nprev = hn.lst
    hn.lst = n
}

pred remove[n:Node, hn:HeadNode] {
    n.nprev.nnext = n.nnext
    n.nnext.nprev = n.nprev
}

run { } 