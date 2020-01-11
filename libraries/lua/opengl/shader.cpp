#include "shader.h"

Shader::Shader(const char* vert, const char* frag){
  _program = glCreateProgram();
  ok = compileShader(vert, GL_VERTEX_SHADER)
    && compileShader(frag, GL_FRAGMENT_SHADER)
    && link();
}

Shader::~Shader() {
  glUseProgram(0);
    
  for (auto i : shaders) {
    glDetachShader(_program, i);
  }
    
  glDeleteProgram(_program);
    
  for (auto i : shaders){
    glDeleteShader(i);
  }
}
  
GLuint Shader::program() {
  return _program;
}

bool Shader::isOk() {
  return ok;
}

bool Shader::compileShader(const char* path, GLenum shaderType) {
  GLuint shader = loadShader(path, shaderType);

  glCompileShader(shader);
 
  GLint success = 0;
  glGetShaderiv(shader, GL_COMPILE_STATUS, &success);

  if (!success) {
    printShaderInfoLog(shader);
    return false;
  }
    
  glAttachShader(_program, shader);
  shaders.push_back(shader);
  return true;
}

GLuint Shader::loadShader(const char* path, GLenum shaderType) {
  Sint64 size;
  const char* contents = fileRead(path, size);
  GLint glSize = static_cast<GLuint>(size);
  GLuint shader = glCreateShader(shaderType);

  glShaderSource(shader, 1, &contents, &glSize);

  delete[] contents;
  return shader;
}

bool Shader::link() {
  glLinkProgram(_program);
 
  int success;
  glGetProgramiv(_program, GL_LINK_STATUS, &success);

  if (!success) {
    printProgramInfoLog(_program);
  }

  return success;
}

void Shader::printShaderInfoLog(GLuint shader) {
  GLsizei size;
  glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &size);

  GLchar* error = new GLchar[size];
  glGetShaderInfoLog(shader, size, &size, error);
  error[size] = 0;
    
  printInfoLog("Shader", error);
    
  delete[] error;
}

void Shader::printProgramInfoLog(GLuint program) {
  GLsizei size;
  glGetProgramiv(_program, GL_INFO_LOG_LENGTH, &size);

  GLchar* error = new GLchar[size];
  glGetProgramInfoLog(_program, size, &size, error);
  error[size] = 0;
    
  printInfoLog("Program", error);
    
  delete[] error;
}

void Shader::printInfoLog(const char* name, const char* error) {
  printf("\n== %s Error ==\n", name);
  printf("\n%s\n\n== end ==\n\n", error);
  fflush(stdin);
}