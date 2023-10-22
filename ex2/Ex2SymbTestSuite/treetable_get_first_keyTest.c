#include "klee/klee.h"
#include <assert.h>
#include "../treetable.h"

int main () {
    //treetable_get_first_key test

    TreeTable *tt;
    treetable_new(&tt);

    int a_key, a_val;
    klee_make_symbolic(&a_key, sizeof(int), "a_key");
    klee_make_symbolic(&a_val, sizeof(int), "a_val");

    void *out;
    assert(treetable_get_first_key(tt, &out) == CC_ERR_KEY_NOT_FOUND);
    
    treetable_add(tt, &a_key, &a_val);

    assert(tt != NULL);

    assert(treetable_get_first_key(tt, &out) == CC_OK && out == &a_key);

    treetable_destroy(tt);
    
    return 0;
}