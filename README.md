# Hello Exec Web

Start a Web Application by Native App.


## Quick Start

```bash
git clone https://github.com/livebook-dev/livebook.git
cd livebook/elixirkit

git clone https://github.com/thaddeusjiang-demo/hello_exec_web
cd hello_exec_web/
mix deps.get
```

```bash
cd rel/appkit
bin/run
```

This will:
1. Build the Swift launcher
2. Build the Phoenix application
3. Start the application and automatically open browser at http://localhost:4000

## Architecture

- **Phoenix LiveView**: Provides modern web interface
- **AppKit Launcher**: Minimal launcher with no UI, only responsible for starting Phoenix and opening browser
- **ElixirKit Integration**: Phoenix and AppKit communicate bidirectionally through ElixirKit

## Features

- Real-time counter (LiveView interaction)
- Activity log display
- ElixirKit message passing capabilities
- Modern responsive UI (Tailwind CSS)
