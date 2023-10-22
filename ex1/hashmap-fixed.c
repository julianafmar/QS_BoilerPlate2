/* Copyright (C) 2014  Richard Wiedenhöft <richard.wiedenhoeft@gmail.com>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#include "hashmap.h"
#include <assert.h>
#include <string.h>

unsigned long int hashmap_fnv1a(void *data, unsigned long int len) {
  unsigned char *p = (unsigned char *)data;
  unsigned long int h = 2166136261UL;
  unsigned long int i;

  for (i = 0; i < len; i++) {
    h = (h ^ p[i]) * 16777619;
  }

  return h;
}

int hashmap_hash(char *str, int max_hash) {
  unsigned long int fnv1a_hash = hashmap_fnv1a((void *)str, strlen(str));
  int hash = (int)(fnv1a_hash % (max_hash + 1));
  return hash;
}

struct hashmap_s {
  int size;
  struct hashmap_field *fields;
};

struct hashmap_field {
  int size;
  struct hashmap_entry *entries;
};

struct hashmap_entry {
  char *key;
  void *val;
  size_t len;
};

hashmap_t hashmap_new(int size) {
  hashmap_t map = (hashmap_t)malloc(sizeof(struct hashmap_s));

  /* BUG-5 */
  if(map == NULL) {
    exit(1);
  }
  /* Fixes 5 */

  struct hashmap_field *fields =
      (struct hashmap_field *)malloc(sizeof(struct hashmap_field) * size);

  if (!fields) {
    free(map);
    /* BUG-12 */
    exit(1);
    /* Fixes 12 */
  }

  for (int i = 0; i < size; i++) {
    struct hashmap_field *field = &fields[i];
    /* BUG-6 */
    if(field != NULL) {
      field->size = 0;
      field->entries = NULL;
    }
    /* Fixes 6*/
  }

  /* BUG-1 */
  if(map == NULL) exit(1);
  /* Fixes 1*/
    
  map->size = size;
  map->fields = fields;

  return map;
}

void hashmap_free(hashmap_t map) {
  for (int i = 0; i < map->size; i++) {
    struct hashmap_field *field = map->fields + i;
    if (field->entries != 0) {
      int j;
      for (j = 0; j < field->size; j++) {
        struct hashmap_entry *entry = field->entries + j;
        free(entry->key);
        free(entry->val);
      }
      free(field->entries);
    }
  }
  free(map->fields);
  free(map);
}

void hashmap_set(hashmap_t map, char *key, void *value, size_t length) {
  int hash = hashmap_hash(key, map->size - 1);
  struct hashmap_field *field = map->fields + hash;
  struct hashmap_entry *entry;

  int i;
  for (i = 0; i < field->size; i++) {
    entry = field->entries + i;
    if (strcmp(entry->key, key) == 0) {
      free(entry->val);
      goto set_val;
    }
  }

  if (value == NULL) {
    return;
  }

  field->size++;
  struct hashmap_entry *entries = (struct hashmap_entry *)malloc(
      field->size * sizeof(struct hashmap_entry));
  /* BUG-10 */
  if (size(entries) >= (field->size - 1) * sizeof(struct hashmap_entry) 
      && size(field->entries) >= (field->size - 1) * sizeof(struct hashmap_entry))
    memcpy(entries, field->entries,
         (field->size - 1) * sizeof(struct hashmap_entry));
  else exit(1);
  /* Fixes 10 */

  entry = &entries[field->size - 1];
  entry->key = (char *)malloc(sizeof(key));
  /* BUG-9 */
  if(size(entry->key) >= size(key)) {
    strcpy(entry->key, key);
  } else exit(1);
  /* Fixes 9 */

  field->entries = entries;

  /* BUG-2 */
  free(entries);
  /* Fixes 2*/

set_val:
  if (value != NULL) {
    void *val = malloc(length);

    /* BUG-11*/ if (size(val) >= length && size(value) >= length && /* BUG-4 */ val != NULL) {
      entry->val = memcpy(val, value, length);
    } 
    /* BUG-3*/ 
    else {
      free(val);
      exit(1);
    }
    /* Fixes 3 */
    /* Fixes 4*/
    /* Fixes 11*/
    entry->len = length;
  } else {
    free(entry->key);
    field->size--;
    if (entry != (field->entries + field->size)) {
      memcpy((void *)entry, (void *)(field->entries + field->size),
             sizeof(struct hashmap_entry));
    }
    field->entries = realloc((void *)field->entries,
                             field->size * sizeof(struct hashmap_entry));
  }
}

void *hashmap_get(hashmap_t map, char *key) {
  int hash = hashmap_hash(key, map->size - 1);
  struct hashmap_field *field = map->fields + hash;
  struct hashmap_entry *entry;

  int i;
  for (i = 0; i < field->size; i++) {
    entry = field->entries + i;
    if (strcmp(entry->key, key) == 0) {
      void *val = malloc(entry->len);
      if(val != NULL) {
        void *ret = memcpy(val, entry->val, entry->len);
        free(val);
        return ret;
      }
    }
  }
  return NULL;
}

int main() {
  hashmap_t map = hashmap_new(8);

  char *key = "42";
  int value = 42;
  hashmap_set(map, key, &value, sizeof(int));

  int *ret = (int *)hashmap_get(map, key);
  assert(*ret == value);
  /* BUG-8 */
  free(ret); // Verificar
  /* Fixes 8 */

  hashmap_free(map);
  return 0;
}
