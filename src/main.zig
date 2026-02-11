const std = @import("std");
const glfw = @import("zglfw");
const zopengl = @import("zopengl");


pub fn main() !void {
    try glfw.init();
    defer glfw.terminate();

    const window = try glfw.createWindow(640, 480, "Hello World", null, null);
    defer window.destroy();

    glfw.makeContextCurrent(window);

    try zopengl.loadCoreProfile(&glfw.getProcAddress, 4, 1);
    const gl = zopengl.bindings;
    const Uint = gl.Uint;

    const position_attib_index: Uint = 0;
    const positions = [_]f32{
        0.0, 0.0,
        0.5, 0.0,
        0.5, 0.5,
        0.0, 0.5
    };

    var va: Uint = undefined;
    gl.genVertexArrays(1, &va);
    gl.bindVertexArray(va);

    var positions_buffer: Uint = undefined;
    gl.genBuffers(1, &positions_buffer);
    gl.bindBuffer(gl.ARRAY_BUFFER, positions_buffer);

    gl.bufferData(gl.ARRAY_BUFFER, @sizeOf(@TypeOf(positions)), &positions, gl.STATIC_DRAW);

    gl.enableVertexAttribArray(position_attib_index);

    gl.vertexAttribPointer(position_attib_index, 2, gl.FLOAT, gl.FALSE, 0, null);


    const color_attrib_index = 1;
    const colors = [_]f32{
        1.0, 0.0, 0.0,
        0.0, 1.0, 0.0,
        0.0, 0.0, 1.0,
        1.0, 1.0, 1.0,
    };

    var color_buffer: Uint = undefined;

    gl.genBuffers(1, &color_buffer);
    gl.bindBuffer(gl.ARRAY_BUFFER, color_buffer);

    gl.bufferData(gl.ARRAY_BUFFER, @sizeOf(@TypeOf(colors)), &colors, gl.STATIC_DRAW);

    gl.enableVertexAttribArray(color_attrib_index);

    gl.vertexAttribPointer(color_attrib_index, 3, gl.FLOAT, gl.FALSE, 0, null);

    const indices = [_]Uint{0, 1, 2, 0, 2, 3};
    const index_buffer: Uint= undefined;

    gl.genBuffers(1, index_buffer);
    gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, index_buffer);
    gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, @sizeOf(@TypeOf(indices)), &indices, gl.STATIC_DRAW);

    // “Treat this pointer-to-array as a C pointer to its first byte.”
    const vs_ptr: [*c] const u8 = @ptrCast(@embedFile("basic.vert"));
    // “Create an array of C string pointers, because OpenGL expects char**.”
    const vs_ptr_array = [_][*c]const u8{ vs_ptr };

    const vs: Uint = gl.createShader(gl.VERTEX_SHADER);
    //                    ⬐pointer to the first element of an array of C string pointers
    gl.shaderSource(vs, 1, &vs_ptr_array, null);
    gl.compileShader(vs);




    while (!glfw.windowShouldClose(window)) {
        gl.clear(gl.COLOR_BUFFER_BIT);

        window.swapBuffers();

        glfw.pollEvents();
    }

}
