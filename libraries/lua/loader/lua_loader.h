#ifndef _LUA_LOADER_H_
#define _LUA_LOADER_H_

#include "lua_include.h"
#include "lua_map.h"
#include "lua_music.h"
#include "lua_sprite.h"
#include "lua_static.h"
#include "bound_surface.h"
#include "lua_texture.h"
#include "lua_ttf.h"
#include "bound_shader.h"
#include "bound_gl_static.h"
#include "bound_glm_static.h"
#include "bound_float_array.h"
#include "bound_uint_array.h"
#include "bound_mat4.h"
#include "bound_vec3.h"

/**
   loads the sprite library into lua
 */
int luaopen_gamelibs(lua_State *L);

#endif