#include "klee/klee.h"
#include <assert.h>
#include "treetable.h"

int main () {
    //treetable_get test

    TreeTable *tt;
    treetable_new(&tt);

    void *a_key, *a_val, *b_key, *b_val;
    klee_make_symbolic(&a_key, sizeof(void), "a_key");
    klee_make_symbolic(&b_key, sizeof(void), "b_key");
    klee_make_symbolic(&a_val, sizeof(void), "a_val");
    klee_make_symbolic(&b_val, sizeof(void), "b_val");

    treetable_add(tt, a_key, a_val);
    treetable_add(tt, b_key, b_val);

    assert(tt != NULL);

    void *out;
    assert(treetable_get(tt, a_key, &out) == CC_OK && out == a_val);
    assert(treetable_get(tt, b_key, &out) == CC_OK && out == b_val);

    treetable_destroy(tt);

    return 0;
}