#include "klee/klee.h"
#include <assert.h>
#include "treetable.h"

int main () {
    //treetable_get test
    
    TreeTable *tt;
    treetable_new(&tt);

    int a_key, a_val, b_key, b_val; 
    klee_make_symbolic(&a_key, sizeof(int), "a_key");
    klee_make_symbolic(&b_key, sizeof(int), "b_key");
    klee_make_symbolic(&a_val, sizeof(int), "a_val");
    klee_make_symbolic(&b_val, sizeof(int), "b_val");

    treetable_add(tt, a_key, a_val);
    treetable_add(tt, b_key, b_val);

    assert(tt != NULL);

    assert(treetable_contains_key(tt, a_key));
    size_t x = treetable_contains_value(tt, a_val);
    assert(x == 1);

    assert(treetable_contains_key(tt, b_key));
    x = treetable_contains_value(tt, b_val);
    assert(x == 1);

    treetable_destroy(tt);

    return 0;
}