#include "klee/klee.h"
#include <assert.h>
#include "treetable.h"

int main () {
    //treetable_get test
    
    TreeTable *tt;
    treetable_new(&tt);

    int a_key =  0, a_val =  0, b_key = 16777216, b_val = 0, c_key = -2147483648, c_val = 0, d_key = 0, d_val = 0; 

    treetable_add(tt, &a_key, &a_val);
    treetable_add(tt, &b_key, &b_val);
    treetable_add(tt, &c_key, &c_val);
    treetable_add(tt, &d_key, &d_val);

    assert(tt != NULL);

    assert(treetable_contains_key(tt, &a_key));

    assert(treetable_contains_key(tt, &b_key));

    assert(treetable_contains_key(tt, &c_key));

    assert(treetable_contains_key(tt, &d_key));

    treetable_destroy(tt);

    return 0;
}