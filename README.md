We've already covered why Elixir and Phoenix are worth a try, but making the switch can be tricky. Elixir is a world apart from the JavaScript ecosystem, but we're here to offer you a familiar reference point as you dive in. To do this, we're crafting a series of articles that explain Elixir using JavaScript lingo. So, without further ado, let's kick things off by diving into what Elixir is, how to get it up and running, and to wrap things up, we'll show you how to create a "Hello, world!" application in a few different ways.

# What is Elixir?

Elixir is a dynamic, functional programming language. This should not be so strange, as JavaScript is also dynamic and provides some functional aspects, like `Array.prototype.map`/`filter`/`reduce` and friends. In recent years, JavaScript has also moved away from APIs that mutate data and started to embrace a more immutable paradigm, where methods return new updated values, instead of overwriting the object they were called on.

Elixir runs on the Erlang Virtual Machine (called BEAM), which is somewhat analogous to how V8 works for Node.js. You might know that Erlang is also a language in its own right, so what's the deal? Just as with V8, which supports different languages like TypeScript, ClojureScript, Scala.js, and CoffeeScript (RIP), BEAM has its unique ecosystem. However, while TypeScript and others compile to JavaScript, both Elixir and Erlang compile into BEAM bytecode. This setup is more similar to JVM languages like Java, Scala, Clojure, and Kotlin. If you're not familar with these, think of it as when JavaScript is parsed, it would be compiled into wasm instrucutions. In that case, JS would also be a wasm target like all other languages that have a wasm compiler: C++, Rust, Go etc.

However, the BEAM is not like any other VM. It would be beyond the scope of this post to delve into the fault tolerance provided by this technology, but as you write your code in Elixir, you'll notice that when something breaks, the effect is similar to that in JavaScript: only the part of the application where you had the error breaks, and the rest continues to function. But you'll probably find it much more difficult to crash an entire Elixir application than a Node.js backend. The reason behind this is Elixir's concurrency model, which is based on lightweight BEAM processes functioning as actors, in line with the [actor model](https://en.wikipedia.org/wiki/Actor_model). This makes reasoning about your code in Elixir a lot easier than in Node.js. Most tasks run in separate processes, so many operations can be synchronous. It's akin to using worker threads for every request your server handles, but much more lightweight and easier to manage. However, unlike worker threads, or threads in general, BEAM processes don't share memory, making it very difficult – if not virtually impossible – to encounter race conditions. That's one of the reasons why Elixir has gained popularity, particularly for developing robust and scalable web applications using the Phoenix framework.

While we're on the topic, let's touch on OTP. When installing Elixir, you'll also need to install Erlang, ensuring that their versions are compatible. Most of the time, however, the Erlang version will be referred to as the Erlang/OTP version or simply the OTP version. OTP comprises a set of libraries usable in both Erlang and Elixir. But it's not your typical lodash or express. It includes abstractions over BEAM processes, an Application concept, a method for communication between BEAM nodes, a Redis-like distributed term storage called [ETS](https://hexdocs.pm/elixir/main/ets.html), and [Mnesia](https://en.wikipedia.org/wiki/Mnesia), which is AN ACTUAL BUILT-IN DATABASE similar to MongoDB.

And let's pause for a moment to talk about communicating between BEAM nodes. Essentially, you can start Elixir apps on different machines, link them together, and then call functions from one node on another. There's no need for HTTP, messaging queues, or REST APIs. You simply call the function on one machine and receive the result from another. 

![Exploding brain](https://media1.giphy.com/media/26ufdipQqU2lhNA4g/giphy.gif?cid=ecf05e47bjawp70bfkc13g99iylbvfa28f5sq5cwl51v3okq&ep=v1_gifs_search&rid=giphy.gif&ct=g)

This is why it was so straightforward for Chris McCord to implement Fly.io's [FLAME](https://fly.io/blog/rethinking-serverless-with-flame/) serverless/lambda-like service for Elixir. FLAME's spiritual predecessor, [Modal](https://modal.com/) was developed for machine learning in Python, but it took an entire company and years to complete.

# How to install Elixir?

Just like with Node.js, you there are multiple ways to install Elixir. You can use your OS's package manager, run it with Docker, or download prebuilt binaries. However, you'll probably want to be able to control which version of Elixir you're using, so the best is to use a version manager. 

## What's up with Elixir and Erlang compatibility?
When working with Elixir and Erlang, it's generally recommended to use compatible versions of both to avoid potential issues. The compatibility between Elixir and Erlang versions is crucial, as certain features or enhancements in Elixir may rely on specific Erlang/OTP releases, given their shared execution environment on the BEAM virtual machine. 
If you install incompatible versions, you might encounter issues such as:
- **Functionality Breakage**: Certain Elixir features may depend on Erlang/OTP features introduced in specific versions.
- **Performance Issues**: Newer versions of Erlang/OTP often come with performance improvements and bug fixes.
- **Potential Bugs**: Running Elixir on an incompatible Erlang version may lead to unexpected behavior, errors, or even crashes due to mismatches in the underlying runtime.

Checking the compatibility matrix in the [Elixir documentation](https://hexdocs.pm/elixir/1.12/compatibility-and-deprecations.html#compatibility-between-elixir-and-erlang-otp) is a recommended approach. For optimal performance, use the Erlang version against which Elixir was compiled. To determine the necessary version, execute `elixir -v`, as illustrated below:

!["elixir-v"](/images/installation/elixir-v.png)

Of course it's a bit of a catch-22 situation where first you need to install Erlang based on the compatibility table, then pull the desired Elixir version, and only after that can you check if it was built with the Erlang version you have on disk. If it's not you pull the right Erlang version again and set it as the default instead of the already exisiting one. Phew, that's a mouthful. However, it's pretty quick to do this raindance and it won't often happen either. If you stick with the latest Elixir and the latest compatible Erlang, you'll be fine most of the time.

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
- At this point we still need to set the versions we want to use. 
- When we wanted to set the global Node version with **nvm** we aliased the desired version as *default* or used the `nvm use <version>` command. On project level we used an `.nvmrc` file and defined the desired version there.

- With **asdf** you also has the option to set version on both, global or local level. Here is how you do it:

1. Global

```
$ asdf global erlang 26.2.1

$ asdf global elixir 1.16.0-otp-26
```

2. Local
- In you projects root directory run the following command:

```
$ asdf local elixir 1.16.0-otp-26

$ asdf local erlang 26.2.1
```

- This will create a `.tool-versions` file with the defined versions like this:

!["tool-versions"](/images/installation/tool-versions.png)

# Hello World in Elixir
- First launch an IEx (Interactive Elixir) in the terminal:

!["iex-launch"](/images/hello_world/iex.png)

- Now you can run Elixir code in your terminal:

!["elixir-hello-world-terminal"](/images/hello_world/elixir-hello-world-terminal.png)

- IEx will print the message and then display the return value of a function, which is an atom `:ok`(indicating that the function exectued successfully)

- Alternatively we can put this one line of code to its own file. Let's call it `hello_world.exs`:

!["elixir-hello-world-file"](/images/hello_world/elixir-hello-world-file.png)

- We can execute this script like this:

```
$ elixir hello_world.exs
```

!["elixir-hello-world-execution"](/images/hello_world/elixir-hello-world-file-execute.png)

- Let's create or first Elixir project with the help of **mix**, which is a build tool and task runner for the Elixir programming language.
- In your terminal run the following command:

```
$ mix new elixir_hello_world
```


## Where to go from here?
- Thank you for reviewing this shprt installation guide for Elixir. Future articles on this subject will be published to provide further insights and guidance.
- In the meantime, we recommend exploring the official documentation for Elixir and Phoenix, integral resources for in-depth knowledge:
    - [elixir-lang.org](https://elixir-lang.org/docs.html)
    - [elixirschool.com](https://elixirschool.com/en)

- Also take a look at Phoenix, which is the most used web framework for Elixir:
    - [Phoenix framework](https://hexdocs.pm/phoenix/Phoenix.html)
