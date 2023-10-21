#include "klee/klee.h"
#include <assert.h>
#include "treetable.h"

int main () {
    //treetable_get test
    
    TreeTable *tt;
    treetable_new(&tt);

    int a_key, a_val, b_key, b_val, c_key, c_val, d_key, d_val; 
    klee_make_symbolic(&a_key, sizeof(int), "a_key");
    klee_make_symbolic(&b_key, sizeof(int), "b_key");
    klee_make_symbolic(&c_key, sizeof(int), "c_key");
    klee_make_symbolic(&d_key, sizeof(int), "d_key");
    klee_make_symbolic(&a_val, sizeof(int), "a_val");
    klee_make_symbolic(&b_val, sizeof(int), "b_val");
    klee_make_symbolic(&c_val, sizeof(int), "c_val");
    klee_make_symbolic(&d_val, sizeof(int), "d_val");

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