
{
  build_id=$1
  build_dsp=$2

  cd builds/$build_id

  # docker run --rm -v $(pwd):/root --user $(id -u):$(id -g) foobar:latest -linux -unpacked $build_dsp
  docker run --rm -v $(pwd):/root --user $(id -u):$(id -g) foobar:latest -android -w64 -linux -unpacked $build_dsp 2>&1 | tee log.txt

  build_file=""

  for entry in ./FaustPlugin*
  do
    build_file="$entry"
    break
  done

  zip -r $build_file.zip $build_file 2>&1 | tee -a log.txt

  echo "$build_file.zip" > file
} 1>/dev/null 2>&1 &
