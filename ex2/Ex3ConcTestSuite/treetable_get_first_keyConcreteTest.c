#include "klee/klee.h"
#include <assert.h>
#include "../treetable.h"

//treetable_get_first_key concrete test

void get_first_test() {
    TreeTable *tt;
    treetable_new(&tt);

    int a_key = 0;
    char a_val[] = "..";
    void *out;

    assert(treetable_get_first_key(tt, &out) == CC_ERR_KEY_NOT_FOUND);
    treetable_add(tt, &a_key, a_val);

    assert(tt != NULL);

    assert(treetable_get_first_key(tt, &out) == CC_OK && out == &a_key);

    treetable_destroy(tt);
}
