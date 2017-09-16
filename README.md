# FindLine
A simple grep-like script written in Ruby

**Usage:** `./find_line directory_path regexp output_file_name_suffix(optional)`

- `directory path` - directory with files to search for occurrences of the pattern
- `regexp` - pattern occurrences of which to search for
- `output_file_name_suffix` - output file will be named result_#{output_file_name_suffix}.txt if this parameter is specified,
    otherwise it will be named result_#{regexp.inspect}.txt
    
Script stores log files in directory specified in `LOG_PATH` environmental variable.
If that variable is not set, log files are being stored in the directory containing the script.  

Script stores result files in directory specified in `OUTPUT_DIR` environmental variable.
If that variable is not set, result files are being stored in the directory containing the script.  
    
**Warning:** if your regexp contains characters that cannot be a part of file name in your operating system, the script will 
exit with error unless `output_file_name_suffix` is specified     

### Docker usage ###

#### With git repository ####
```bash
git clone https://github.com/Forinil/find_line.git
cd find_line
docker build -t find_line .
docker run -it --rm -v `$(pwd)`:/app/output find_line directory_path regexp output_file_name_suffix(optional)
```

#### With docker repository ####
[Docker Hub repository](https://hub.docker.com/r/forinil/find_line/)
```bash
docker pull forinil/find_line
docker -t forinil/find_line find_line
docker run -it --rm -v `$(pwd)`:/app/output find_line directory_path directory_path regexp output_file_name_suffix(optional)
```

Of course there is no need to tag docker repository image with shorter name before using it, it is simply 
more convenient for repeated use.

Invoking docker run command as described above will copy the results to your current working directory.

If you want to access application log files after running docker image, you must mount a host directory to one inside the container 
and point the application to it by either specifying `log_dir` parameter or `LOG_PATH` variable (especially if you wish to avoid specifying
regular expression as well).

For example:
```bash
docker run -it --rm -v `$(pwd)`:/app/output -v `$(pwd)`/logs:/app/logs -e LOG_PATH=/app/logs directory_path regexp output_file_name_suffix(optional)
```

The above command will work assuming there is a directory named logs in your current working directory