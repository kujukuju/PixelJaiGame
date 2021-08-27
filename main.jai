#import "Basic";
#import "Compiler";
#import "File_Utilities";
#import "String";

build :: () {
    context.allocator = __temporary_allocator;

    current_workspace := get_current_workspace();
    build_options := get_build_options();
    build_options.output_type = .NO_OUTPUT;
    set_build_options(build_options, current_workspace);

    workspace := compiler_create_workspace("Pixel Game");
    build_options.output_type = .EXECUTABLE;
    build_options.output_executable_name = "main";
    build_options.temporary_storage_size = 2097152;

    //print("Module folder original: %\n", build_options.import_path);
    build_options.import_path = .[#run tprint("C:/jai/modules"), #run tprint("%libs", #filepath)];
    // array_add(*build_options.import_path, tprint("\"%modules\"", #filepath));
    print("Module folders: %\n", build_options.import_path);
    set_build_options(build_options, workspace);

    set_working_directory(#filepath);

    // build options
    // target_options := get_build_options(w);
    // target_options.output_executable_name = "main";
    // target_options.temporary_storage_size = 2097152;
    // array_add(*target_options.modules_search_path_array, tprint("\"%modules\"", #filepath));

    // source files
    files := file_list(tprint("%src", #filepath), true);
    for file : files {
         // skip non-jai source files
        if (!ends_with(file, ".jai")) {
            continue;
        }

        print("Build file: %\n", file);
        add_build_file(file, workspace);
    }

    // this is the metaprogram
    // options := get_build_options();
    // options.output_type = .NO_OUTPUT;
    // set_build_options(options);
}

#run build();
