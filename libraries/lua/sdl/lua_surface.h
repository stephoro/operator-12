#ifndef _LUA_SURFACE_H_
#define _LUA_SURFACE_H_
#include "globals.h"
#include "util_lua.h"

SDL_Surface* surface_newBlank(lua_Integer width, lua_Integer height);
void surface_destroy(SDL_Surface* self);

#endif
