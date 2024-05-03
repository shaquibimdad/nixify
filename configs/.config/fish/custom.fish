alias ls="exa --icons"

alias activate="source /media/shaquib/projects/python-venvs/django/bin/activate.fish"

alias __dvr="__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia /opt/resolve/bin/resolve"

# gpg-agent
export GPG_TTY=$(tty)

# ccache env-setup
# export CCACHE_SLOPPINESS=clang_index_store,file_stat_matches,include_file_ctime,include_file_mtime,ivfsoverlay,pch_defines,modules,system_headers,time_macros
# export CCACHE_FILECLONE=true
# export CCACHE_DEPEND=true
# export CCACHE_INODECACHE=true

#compile run delemte he he bwoi!!
alias runcpp 'g++ $argv[1] -o output; ./output; rm -f output'

#DSA
function ppp
  set name $argv[1]
    #set value $argv[2]
    #echo $value
  g++ -o $name $name.cpp && ./$name < input.txt > output.txt && rm $name
end


function repopkg
  set name $argv[1]
    pacman -Sl $argv[1] | grep "\[installed\]"
end

