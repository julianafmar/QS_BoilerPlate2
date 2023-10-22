#include "klee/klee.h"
#include <assert.h>
#include "../treetable.h"

int main () {
    //treetable_greater_than test

    TreeTable *tt;
    treetable_new(&tt);

    int a_key, a_val, b_key, b_val;
    klee_make_symbolic(&a_key, sizeof(int), "a_key");
    klee_make_symbolic(&b_key, sizeof(int), "b_key");
    klee_make_symbolic(&a_val, sizeof(int), "a_val");
    klee_make_symbolic(&b_val, sizeof(int), "b_val");

    void *out;
    assert(treetable_get_greater_than(tt, &a_key, &out) == CC_ERR_KEY_NOT_FOUND);
    
    treetable_add(tt, &a_key, &a_val);
    treetable_add(tt, &b_key, &b_val);

    assert(tt != NULL);

    if (a_key < b_key) assert(treetable_get_greater_than(tt, &a_key, &out) == CC_OK && out == &b_key);
    else if (a_key > b_key) assert(treetable_get_greater_than(tt, &b_key, &out) == CC_OK && out == &a_key);

    treetable_destroy(tt);
    
    return 0;
}