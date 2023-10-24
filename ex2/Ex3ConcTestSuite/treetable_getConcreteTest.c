#include "klee/klee.h"
#include <assert.h>
#include "../treetable.h"

//treetable_get concrete tests

void tt_get_test1 () {
    TreeTable *tt;
    treetable_new(&tt);

    int a_key = 0, b_key = 0;
    char a_val[] = "..", b_val[] = "..";

    treetable_add(tt, &a_key, a_val);

    assert(tt != NULL);

    void *out;
    assert(treetable_get(tt, &a_key, &out) == CC_OK && strcmp(out, a_val) == 0);
    if (a_key != b_key) assert(treetable_get(tt, &b_key, &out) == CC_ERR_KEY_NOT_FOUND);

    treetable_destroy(tt);
}

void tt_get_test2 () {
    TreeTable *tt;
    treetable_new(&tt);

    int a_key = 16777216, b_key = 0;
    char a_val[] = "..", b_val[] = "..";

    treetable_add(tt, &a_key, a_val);

    assert(tt != NULL);

    void *out;
    assert(treetable_get(tt, &a_key, &out) == CC_OK && strcmp(out, a_val) == 0);
    if (a_key != b_key) assert(treetable_get(tt, &b_key, &out) == CC_ERR_KEY_NOT_FOUND);

    treetable_destroy(tt);
}

void tt_get_test3 () {
    TreeTable *tt;
    treetable_new(&tt);

    int a_key = 0, b_key = 16777217;
    char a_val[] = "..", b_val[] = "..";

    treetable_add(tt, &a_key, a_val);

    assert(tt != NULL);

    void *out;
    assert(treetable_get(tt, &a_key, &out) == CC_OK && strcmp(out, a_val) == 0);
    if (a_key != b_key) assert(treetable_get(tt, &b_key, &out) == CC_ERR_KEY_NOT_FOUND);

    treetable_destroy(tt);
}
