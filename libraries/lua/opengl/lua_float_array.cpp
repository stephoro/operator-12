#include "lua_gl_static.h"

/**
   @lua-name new
   @lua-arg length: int
   @lua-return Struct VoidArray FloatArray
 */
static VoidArray float_array_new(lua_Integer length) {
  VoidArray array;
  array.data = reinterpret_cast<void*>(new GLfloat[length]);
  array.length = length;
  return array;
}

/**
   If indexing with a number, return the number at that index,
   otherwise, fetch whatever value is stored in the metatable for that key

   @lua-meta
   @lua-name __index
 */
static int __index(lua_State *L) {
  VoidArray* self;
  if (lua_isnumber(L, -1)) {
    lua_Integer key = lua_tointeger(L, -1);
    lua_pop(L, 1);

    if (!lua_isuserdata(L, -1)) {
      return 0;
    }
    self = reinterpret_cast<VoidArray*>(lua_touserdata(L, -1));
    if (self->data == NULL) {
      return 0;
    }

    if (key < 0 || key >= self->length) {
      return 0;
    }

    lua_pushnumber(L, reinterpret_cast<GLfloat*>(self->data)[key]);
    return 1;
  }

  lua_getmetatable(L, -2);
  // table
  // str
  // meta
  lua_replace(L, -3);
  // meta
  // str
  lua_gettable(L, -2);
  // meta
  // val
  lua_replace(L, -2);
  // val
  return 1;
}

/**
   do array[number] = number
   @lua-name __newindex
   @lua-arg self: Struct VoidArray
   @lua-arg key: int
   @lua-arg value: number
 */
static void __newindex(VoidArray* self, lua_Integer key, lua_Number value) {
  if (self->data == NULL) {
    return;
  }
  if (key < 0 || key >= self->length) {
    return;
  }
  reinterpret_cast<GLfloat*>(self->data)[key] = value;
}

/**
   get the length
   @lua-name __len
   @lua-arg self: Struct VoidArray
   @lua-return int
 */
static lua_Integer __len(VoidArray* self) {
  if (self->data == NULL) {
    return -1;
  }
  return self->length;
}

/**
   get the size in bytes
   @lua-name bytes
   @lua-arg self: Struct VoidArray
   @lua-return int
 */
static lua_Integer float_array_bytes(VoidArray* self) {
  if (self->data == NULL) {
    return -1;
  }
  return self->length * sizeof(GLfloat);
}

/**
   @lua-name destroy
   @lua-arg self: Struct VoidArray
 */
static void float_array_delete(VoidArray* self) {
  if (self->data == NULL) {
    return;
  }
  delete[] reinterpret_cast<GLfloat*>(self->data);
  self->data = NULL;
}