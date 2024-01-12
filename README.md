# How to install Elixir with asdf?

## What is Elixir?
- Elixir is a dynamic, functional programming language designed for building scalable and maintainable applications. With a focus on developer productivity and performance, Elixir empowers developers to create fault-tolerant and highly concurrent systems effortlessly.
- It runs on the Erlang Virtual Machine (BEAM), inheriting the reliability and fault-tolerance of Erlang. The compilation process involves transforming Elixir source code into Erlang's intermediate representation, and the resulting bytecode is executed by the BEAM runtime - in contrast, JavaScript and TypeScript typically compile to machine-readable JavaScript code.
- Elixir has gained popularity, particularly in the context of developing robust and scalable web applications using the Phoenix framework. 
- Elixir differs from JavaScript in several key aspects. While JavaScript is primarily a front-end language often used for client-side web development, Elixir is a back-end language designed for concurrent, distributed systems.
- Elixir leverages functional programming principles, immutability, and pattern matching, offering a different paradigm compared to JavaScript's more object-oriented and imperative approach.
- Elixir's robust concurrency model, inspired by Erlang's actor-based system, enables seamless scalability and fault tolerance, making it particularly suitable for building reliable and high-performance server-side applications, a domain where JavaScript, traditionally, has been less focused.

## Why is it important to use compatible versions?
- When working with Elixir and Erlang, it's generally recommended to use compatible versions of both to ensure compatibility and avoid potential issues. The compatibility between Elixir and Erlang versions is crucial, as certain features or enhancements in Elixir may rely on specific Erlang/OTP releases, given their shared execution environment on the BEAM virtual machine.
- If you install incompatible versions, you might encounter issues such as:
    - **Functionality Breakage**: Certain Elixir features may depend on Erlang/OTP features introduced in specific versions.
    - **Performance Issues**: Newer versions of Erlang/OTP often come with performance improvements and bug fixes.
    - **Potential Bugs**: Running Elixir on an incompatible Erlang version may lead to unexpected behavior, errors, or even crashes due to mismatches in the underlying runtime.
- To avoid these issues, it's a good practice to check the compatibility matrix provided by the [Elixir documentation](https://hexdocs.pm/elixir/1.12/compatibility-and-deprecations.html#compatibility-between-elixir-and-erlang-otp).
- It's best to use the version of Erlang Elixir was compiled against. You can use `elixir -v` to figure out which version you need, as highlighted below:

!["elixir-v"](/images/installation/elixir-v.png)

## Why use asdf?
- **asdf** is a versatile version manager that supports multiple languages, including Elixir, Erlang, Node.js, Ruby, Python, and more. Using asdf can be worthwhile, especially if you are working on projects that involve multiple languages - in contrast, **nvm** is specifically designed for Node.js, focusing on simplified global and per-project version management for Node.js only
- If you're using asdf to manage your versions, you can set a global version for a language/tool that applies system-wide, or you can specify a version on a per-project basis using configuration files.
- It utilizes a plugin system that allows you to extend its functionality to support additional languages or tools.
- To install **asdf** follow the instructions [here](https://asdf-vm.com/guide/getting-started.html#_3-install-asdf)

## Install Erlang
- The version of Erlang is often referred as the OTP version. You can go a long way with Elixir without understanding what OTP is. Just remember that Erlang/OTP is often used a bit similarly to GNU/Linux and its relation to Erlang is also similar to GNU's relation to Linux.
- First we need to install the asdf plugin that installs Erlang and manages the versions for us.
- The following command adds the Erlang plugin:

```
$ asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git
```

- You can run an `asdf list-all erlang` command: 

!["erlang-versions"](/images/installation/erlang-list-all.png)

- Pick the desired version for Erlang to install with the following command (e.g. for version 26.2.1):

```
$ asdf install erlang 26.2.1
```

## Install Elixir
- For Elixir we need to install the asdf plugin first again:

```
$ asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git
```

- List the available versions with `asdf list-all elixir` and pick the desired version

!["elixir-versions"](/images/installation/elixir-list-all.png)

- :warning: **Please exercise caution when selecting the version. It should be compatible with the Erlang version you have installed before!** :warning:
- In our case, let's pick the latest stable version built with the previously installed Erlang version: `1.16.0-otp-26`

```
$ asdf install elixir 1.16.0-otp-26
```

- After the installation check your Elixir version and you should see the following:

!["elixir-v"](/images/installation/elixir-v.png)

## Activating Elixir and Erlang versions
- Although we installed the versions we want, they aren’t yet activated. There are two ways to activate a version.
    - local
    - global
- Set the global config:


```
$ asdf global erlang 26.2.1

$ asdf global elixir 1.16.0-otp-26
```

# Hello World in Elixir

- Let's write our first very simple program in Elixir, the Hello World.
- First launch an IEx (Interactive Elixir) in the terminal:

!["iex-launch"](/images/hello_world/iex.png)

- Now you can run Elixir code in your terminal.
- Let's just type in `IO.puts("Hello World!")` to the terminal:

!["elixir-hello-world-terminal"](/images/hello_world/elixir-hello-world-terminal.png)

- IEx will print the message and then display the return value of a function, which is an atom `:ok`(indicating that the function exectued successfully)

- Alternatively we can put this one line of code to its own file. Let's call it `hello_world.exs`:

!["elixir-hello-world-file"](/images/hello_world/elixir-hello-world-file.png)

- We can execute this script like this:

```
$ elixir hello_world.exs
```

!["elixir-hello-world-execution"](/images/hello_world/elixir-hello-world-file-execute.png)
