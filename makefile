CXX=g++
OPT=
EIGEN_DIR=$(realpath ../../eigen)
PTEEDITOR_DIR=$(realpath ../../PTEditor)
PTEEDITOR_OBJ=$(PTEEDITOR_DIR)/ptedit.o
UTILS_DIR = $(realpath ../)
CXXFLAGS=$(OPT) -c -g -O2 -Wall -std=c++11 -I $(EIGEN_DIR) -I $(PTEEDITOR_DIR) -I $(UTILS_DIR)
LDFLAGS=


SOURCES=$(shell find src -name "*.cpp")
UTILS_SRC="../utils.cpp"
OBJECTS:=$(SOURCES:src/%.cpp=build/%.o)
EXECUTABLE=cppnn

all: $(SOURCES) dist/$(EXECUTABLE)

run: all
	taskset -c 3 ./dist/$(EXECUTABLE) mnist 44 $(file)

dist/$(EXECUTABLE): $(OBJECTS) build/utils.o $(PARSEO)
	@mkdir -p dist
	$(CXX) build/utils.o $(PTEEDITOR_OBJ) $(OBJECTS) $(PARSEO) $(LDFLAGS) -o $@

build:
	mkdir -p build
	#find src/* -type d -print0 | sed 's/src/build/g' | xargs -r0 mkdir -p

build/%.o: src/%.cpp | build
	$(CXX) $(CXXFLAGS) $< -o $@

build/utils.o: 
	$(CXX) $(CXXFLAGS) ../utils.cpp  -o $@

clean: FORCE
	rm -rf build

rmdist: FORCE
	rm -rf dist/*

FORCE:
