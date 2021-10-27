export JAVA_11_HOME=$(/usr/libexec/java_home -v11)
export JAVA_13_HOME=$(/usr/libexec/java_home -v13)
export JAVA_15_HOME=$(/usr/libexec/java_home -v15)

alias java11='export JAVA_HOME=$JAVA_11_HOME'
alias java13='export JAVA_HOME=$JAVA_13_HOME'
alias java15='export JAVA_HOME=$JAVA_15_HOME'

# default to Java 11
java11

# jdtls's workspace dir of nvim-lspconfig
export WORKSPACE=$HOME/.cache/java-workspace
