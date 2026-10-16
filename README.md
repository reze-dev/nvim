# Neovim 0.12 Systems IDE

A high-performance, Lua-native Neovim 0.12 development environment engineered specifically for low-level systems programming in **C++20/23**, **Rust (2021/2024)**, **Go 1.22+**, **Python 3.12+**, and **Zig (0.13+)** — plus first-class **YAML / Docker / Terraform** infrastructure support.

---

## Table of Contents

1. [Executive Overview & Systems Architecture](#1-executive-overview--systems-architecture)
   - [Architectural Principles](#architectural-principles)
   - [System Topology & Layered Architecture](#system-topology--layered-architecture)
   - [Language Data Flows](#language-data-flows)
   - [DAP & Non-Blocking Runtime Inspection Flow](#dap--non-blocking-runtime-inspection-flow)
2. [Motion Mastery & Navigation Guide](#2-motion-mastery--navigation-guide)
   - [Motion Discipline & Ergonomics Philosophy](#motion-discipline--ergonomics-philosophy)
   - [Hardtime.nvim — Anti-Spam Movement Discipline](#hardtimenvim--anti-spam-movement-discipline)
   - [Precognition.nvim — Visual Prospective Navigation](#precognitionnvim--visual-prospective-navigation)
   - [Flash.nvim — High-Speed 2D & Remote AST Navigation](#flashnvim--high-speed-2d--remote-ast-navigation)
   - [Unified Master Keybinding Matrix](#unified-master-keybinding-matrix)
3. [TDD Workflows for Systems Engineering](#3-tdd-workflows-for-systems-engineering)
   - [C++: Google Test & CTest Test-Driven Development](#c-google-test--ctest-test-driven-development)
   - [Rust: Cargo Testables, Workspace Filtering & Clippy Invariants](#rust-cargo-testables-workspace-filtering--clippy-invariants)
   - [Go: Table-Driven Tests, Subtests, Race Detection & Profiling](#go-table-driven-tests-subtests-race-detection--profiling)
   - [Zig: Standard Test Runner & Canonical Formatting](#zig-simple-unit-tests--canonical-formatting)
4. [Low-Level LLDB Systems Debugging Manual](#4-low-level-lldb-systems-debugging-manual)
   - [Memory Hex Dumps & Data Representation](#memory-hex-dumps--data-representation)
   - [CPU Register Inspection & Architectural Analysis](#cpu-register-inspection--architectural-analysis)
   - [Disassembly, Instruction Stepping & ABI Calling Conventions](#disassembly-instruction-stepping--abi-calling-conventions)
   - [Hardware Watchpoints & CPU Debug Registers](#hardware-watchpoints--cpu-debug-registers)
   - [Compiler Optimization Verification & Performance Analysis](#compiler-optimization-verification--performance-analysis)
5. [Theme Management & Live Palette Sync Guide](#5-theme-management--live-palette-sync-guide)
   - [Base46 Standalone Engine Architecture](#base46-standalone-engine-architecture)
   - [Theme Selection & Persistent State Engine](#theme-selection--persistent-state-engine)
   - [Live Evil-Lualine Palette Recomputation](#live-evil-lualine-palette-recomputation)
6. [Preserved Core Invariants](#6-preserved-core-invariants)
   - [Evil-Lualine Statusline](#evil-lualine-statusline)
   - [Harpoon 2 File Pinning HUD](#harpoon-2-file-pinning-hud)
   - [Oil.nvim Filesystem Buffer Engine](#oilnvim-filesystem-buffer-engine)
7. [Installation, Tooling & Verification](#7-installation-tooling--verification)

---

## 1. Executive Overview & Systems Architecture

### Architectural Principles

This configuration is architected as an industrial-grade systems engineering workstation. It eliminates GUI overhead while providing the deep compiler introspection, structural navigation, and runtime diagnostics required for high-throughput, latency-critical software development.

- **Zero-Latency Feedback Loops**: Built on Neovim 0.12's native LSP architecture (`vim.lsp.config`, `vim.lsp.enable`) paired with `saghen/blink.cmp`—a Rust-compiled fuzzy completion engine providing instant autocompletion, signature help, and inlay hints.
- **Deterministic Tooling Pipeline**: Formatting is owned strictly by `stevearc/conform.nvim`, asynchronous linting by `mfussenegger/nvim-lint`, and test orchestration by `nvim-neotest/neotest`. Each subsystem has a single, unambiguous owner.
- **Runtime Introspection & Debugger Stability**: Non-blocking Debug Adapter Protocol (DAP) integration via CodeLLDB (C++/Rust) and Delve (Go), with crash-resilient UI event handlers (`pcall` wrapped) and real-time inline virtual text variable display.
- **Strict Invariant Preservation**: Core developer ergonomics—specifically `evil-lualine`, `ThePrimeagen/harpoon` (branch `harpoon2`), and `stevearc/oil.nvim`—are maintained with zero regressions.

---

### System Topology & Layered Architecture

```
┌────────────────────────────────────────────────────────────────────────────────────────┐
│                                NEOVIM 0.12 SYSTEMS IDE                                │
├────────────────────────────────────────────────────────────────────────────────────────┤
│  PRESENTATION & ERGONOMICS LAYER                                                      │
│  ┌───────────────────────┐  ┌───────────────────────┐  ┌────────────────────────────┐  │
│  │     Evil-Lualine      │  │     Harpoon 2 HUD     │  │          Oil.nvim          │  │
│  │ (Live Base46 Palette) │  │  (Quick File Pointers)│  │ (Buffer Filesystem Editing)│  │
│  └───────────────────────┘  └───────────────────────┘  └────────────────────────────┘  │
│  ┌──────────────────────────────────────────────────────────────────────────────────┐  │
│  │ Motion & Navigation: Hardtime.nvim ── Precognition.nvim ── Flash.nvim (2D/Remote)│  │
│  └──────────────────────────────────────────────────────────────────────────────────┘  │
├────────────────────────────────────────────────────────────────────────────────────────┤
│  LANGUAGE ANALYSIS & INTELLIGENCE LAYER                                               │
│  ┌──────────────────────────────────────────────────────────────────────────────────┐  │
│  │ Native LSP Client (vim.lsp.config) ── Blink.cmp (Rust Fuzzy Matcher + Inlay Hints)│  │
│  ├────────────────────────┬─────────────────────────┬───────────────────────────────┤  │
│  │        C / C++         │          Rust           │              Go               │  │
│  │  clangd + extensions   │  rustaceanvim + r-a     │      go.nvim + gopls          │  │
│  │ (AST / Type Hierarchy) │  (Clippy / Cargo Macros)│   (Tags / Interface Impl)     │  │
│  └────────────────────────┴─────────────────────────┴───────────────────────────────┘  │
│  ┌──────────────────────────────────────────────────────────────────────────────────┐  │
│  │ nvim-treesitter (AST Highlighting, Incremental Selection <C-space>, Text Objects)│  │
│  └──────────────────────────────────────────────────────────────────────────────────┘  │
├────────────────────────────────────────────────────────────────────────────────────────┤
│  CODE QUALITY & EXECUTION ENGINE                                                      │
│  ┌─────────────────────────────────────┐  ┌─────────────────────────────────────────┐  │
│  │ Formatters (conform.nvim)           │  │ Asynchronous Linters (nvim-lint)        │  │
│  │ clang-format │ rustfmt │ gofumpt     │  │ clang-tidy │ clippy │ golangci-lint     │  │
│  └─────────────────────────────────────┘  └─────────────────────────────────────────┘  │
│  ┌──────────────────────────────────────────────────────────────────────────────────┐  │
│  │ Neotest TDD Engine (neotest-gtest ── rustaceanvim.neotest ── neotest-golang)      │  │
│  └──────────────────────────────────────────────────────────────────────────────────┘  │
├────────────────────────────────────────────────────────────────────────────────────────┤
│  LOW-LEVEL RUNTIME & HARDWARE DEBUGGING LAYER (DAP)                                   │
│  ┌──────────────────────────────────────────────────────────────────────────────────┐  │
│  │ nvim-dap + nvim-dap-ui + nvim-dap-virtual-text (Crash-Safe Stepping State Machine)│  │
│  ├─────────────────────────────────────────┬────────────────────────────────────────┤  │
│  │                CodeLLDB                 │                 Delve                  │  │
│  │  (Memory Hex Dumps, Registers, Vectors, │   (Goroutines, Channel Deadlocks,      │  │
│  │   Disassembly, Hardware Watchpoints)    │    Race Conditions, Memory Escapes)    │  │
│  └─────────────────────────────────────────┴────────────────────────────────────────┘  │
└────────────────────────────────────────────────────────────────────────────────────────┘
```

---

### Language Data Flows

#### 1. C / C++ Systems Pipeline
```
[ C++ Source (.cpp/.hpp) ]
       │
       ├──► Treesitter AST ──────────► Syntax Highlighting, Folding & Text Objects (af, if, ac, ic)
       │
       ├──► clangd LSP Server ──────► AST Hierarchy, Inlay Hints, Memory Layout (clangd_extensions)
       │         ▲
       │         └──────────────────── blink.cmp (Fuzzy Completions & Signature Help)
       │
       ├──► On Save / Write ─────────► conform.nvim (clang-format) ──► Clean Formatted Buffer
       │                              nvim-lint (clang-tidy)       ──► Inline Virtual Diagnostics
       │
       ├──► Test-Driven Dev (TDD) ───► Neotest (neotest-gtest / CTest) ──► Results Summary Tree
       │
       └──► DAP Debugger ────────────► CodeLLDB (x86_64/ARM64 Registers, Memory Dumps, ASM Stepping)
```

#### 2. Rust Systems Pipeline
```
[ Rust Source (.rs) ]
       │
       ├──► rustaceanvim (r-a) ──────► Proc Macro Expansion, Inlay Hints, Type Inference
       │         ▲
       │         └──────────────────── blink.cmp (Extended Client Capabilities)
       │
       ├──► On Save / Check ─────────► rustfmt (conform.nvim) ──► Canonical Rust Formatting
       │                              clippy (checkOnSave)    ──► Strict Systems Lint Diagnostics
       │
       ├──► Test Execution ──────────► Cargo Testables (<leader>rt) / Neotest (rustaceanvim adapter)
       │
       └──► DAP Debugger ────────────► CodeLLDB via rustaceanvim (Demangled Frames, Synthetic Types)
```

#### 3. Go Systems Pipeline
```
[ Go Source (.go) ]
       │
       ├──► gopls (lsp.lua) ─────────► Semantic Tokens, Struct Field Alignment, Nilness Analysis
       │    go.nvim helpers ─────────► Struct Tag Generation (<leader>Ga), Interface Impl (<leader>Gi)
       │         ▲
       │         └──────────────────── blink.cmp (Auto Brackets, Param Help)
       │
       ├──► On Save / Write ─────────► conform.nvim (goimports + gofumpt) ──► Clean AST formatting
       │                              nvim-lint (golangci-lint)           ──► Asynchronous Diagnostics
       │
       ├──► Test & Coverage ─────────► Neotest (neotest-golang) / :GoCoverage (<leader>Gc)
       │
        └──► DAP Debugger ────────────► Delve (`dlv`) via dap.lua adapter (Goroutine Tracing, Stack Dumps)
```

---

### DAP & Non-Blocking Runtime Inspection Flow

```
[ User Event: <leader>dc / <leader>di / <leader>do ]
                       │
                       ▼
          [ nvim-dap Session State ]
                       │
         ┌─────────────┴─────────────┐
         ▼                           ▼
[ CodeLLDB / Delve Engine ]   [ Safe UI Hook (pcall) ]
         │                           │
         │ (Evaluate & Step)         ├──► Event Initialized ──► dapui.open({})
         │                           ├──► Event Terminated  ──► dapui.close({})
         ▼                           └──► Event Exited      ──► dapui.close({})
[ Inline Virtual Text ]
         │
         ├──► Local Variables inline (virt_text_pos = "eol")
         └──► Highlight changed memory addresses
```

---

## 2. Motion Mastery & Navigation Guide

### Motion Discipline & Ergonomics Philosophy

High-performance systems engineering requires navigating multi-thousand-line source files, memory structures, and kernel-level codebases with minimal cognitive overhead and zero wasted keystrokes. The IDE integrates three specialized motion tools configured to reinforce mechanical precision.

---

### Hardtime.nvim — Anti-Spam Movement Discipline

`Hardtime.nvim` trains muscular memory by preventing character spamming (`h`, `j`, `k`, `l`) and encouraging precise, structured motions (`w`, `b`, `e`, `ge`, `f`, `t`, `F`, `T`, `{`, `}`, `Ctrl-d`, `Ctrl-u`).

- **Threshold**: Restricts consecutive single-character directional presses to **3** (`max_count = 3`).
- **Buffer Awareness**: Automatically disabled in non-editing buffers (`oil`, `harpoon`, `dapui_*`, `dap-repl`, `trouble`, `quickfix`, `lazy`, `mason`).
- **Toggle Keybinding**:
  - Press `<leader>uh` to toggle Hardtime on/off.
  - Command: `:Hardtime toggle`

```
  Anti-Pattern (Blocked):    j ──► j ──► j ──► j ──► j   [ BLOCKED by Hardtime ]
  Optimal Systems Motion:    5j   OR   }   OR   <C-d>   OR   f<char>   OR   s<char><char>
```

---

### Precognition.nvim — Visual Prospective Navigation

`Precognition.nvim` renders unobtrusive visual hints directly on the current buffer line, calculating the optimal destinations for `w` (next word), `b` (previous word), `e` (end of word), `ge` (previous end of word), `0` (start of line), and `$` (end of line).

- **Mode**: Starts hidden to keep the viewport clean; activated on demand for unfamiliar code navigation.
- **Toggle Keybinding**:
  - Press `<leader>up` to toggle Precognition visual guide hints.
  - Command: `:Precognition toggle`

---

### Flash.nvim — High-Speed 2D & Remote AST Navigation

`Flash.nvim` provides instantaneous 2-dimensional jumping across the entire visible screen, syntax-tree node jumping, and remote operator execution.

| Key | Mode | Description | Systems Workflow Example |
| :--- | :---: | :--- | :--- |
| `s` | `x, o` | **2-Character Jump** | Press `s` followed by `fn` to instantly jump to a function definition on any visible line. (Normal-mode `s` is left untouched for `nvim-surround`'s `ys`, `cs`, `ds`.) |
| `S` | `n, x, o` | **Treesitter Jump** | Press `S` to highlight entire AST nodes (loops, structs, functions) and select with one key. |
| `r` | `o` | **Remote Flash** | Perform an operator remotely without moving the cursor. E.g., `yr` jumps to and yanks a remote struct definition. |
| `R` | `o, x` | **Treesitter Search** | Search and select Treesitter nodes matching regex across the buffer. |
| `<C-s>`| `c` | **Toggle Flash Search** | Toggle Flash search mode while in standard `/` or `?` command-line search. |

---

### Unified Master Keybinding Matrix

The IDE organizes all capabilities into a clean, collision-free `<leader>` hierarchy (Leader = `Space`).

#### 1. `<leader>f` — Find & Telescope Fuzzy Discovery
| Keybinding | Description | Command / Implementation |
| :--- | :--- | :--- |
| `<leader>ff` | Find Files (including hidden) | `Telescope find_files` |
| `<leader>fg` | Live Grep (Ripgrep across workspace) | `Telescope live_grep` |
| `<leader>fb` | Find Active Buffers | `Telescope buffers` |
| `<leader>fd` | Workspace Diagnostics | `Telescope diagnostics` |
| `<leader>fw` | Find Word Under Cursor | `Telescope grep_string` |
| `<leader>fs` | Document LSP Symbols | `Telescope lsp_document_symbols` |
| `<leader>fS` | Workspace LSP Symbols | `Telescope lsp_workspace_symbols` |
| `<leader>fr` | Recent Files (oldfiles) | `Telescope oldfiles` |
| `<leader>fh` | Help Tags & Documentation | `Telescope help_tags` |
| `<leader>fk` | Keymaps Reference Picker | `Telescope keymaps` |
| `<leader>fc` | Neovim Commands Picker | `Telescope commands` |
| `<leader>fm` | Marks Picker | `Telescope marks` |
| `<leader>ft` | Find TODO Comments | `:TodoTelescope` |
| `<leader>fT` | Find TODO / FIX / FIXME | `:TodoTelescope keywords=TODO,FIX,FIXME` |
| `<leader><leader>` | Resume Last Telescope Search | `Telescope resume` |

#### 2. `<leader>e` — Explorer (Oil.nvim)
| Keybinding | Description | Command / Implementation |
| :--- | :--- | :--- |
| `<leader>e` | Open File Explorer (Oil buffer) | `:Oil` |
| `-` | Open Parent Directory | `:Oil` (parent directory) |

#### 3. `<leader>a` — Harpoon 2 Navigation
| Keybinding | Description | Command / Implementation |
| :--- | :--- | :--- |
| `<leader>a` | Pin Current File to Harpoon | `harpoon:list():add()` |
| `<C-e>` | Toggle Harpoon Quick Menu HUD | `harpoon.ui:toggle_quick_menu()` |
| `<leader>1` | Select Pinned File 1 | `harpoon:list():select(1)` |
| `<leader>2` | Select Pinned File 2 | `harpoon:list():select(2)` |
| `<leader>3` | Select Pinned File 3 | `harpoon:list():select(3)` |
| `<leader>4` | Select Pinned File 4 | `harpoon:list():select(4)` |
| `<leader>5` | Select Pinned File 5 | `harpoon:list():select(5)` |
| `[h` / `]h` | Cycle Previous / Next Pinned File | `harpoon:list():prev()` / `next()` |

#### 4. `<leader>l` — Language Server Protocol (LSP)
| Keybinding | Description | Command / Implementation |
| :--- | :--- | :--- |
| `gd` | Go to Definition | `vim.lsp.buf.definition()` |
| `gD` | Go to Declaration | `vim.lsp.buf.declaration()` |
| `gr` | Go to References | `vim.lsp.buf.references()` |
| `gi` | Go to Implementation | `vim.lsp.buf.implementation()` |
| `<leader>D` | Go to Type Definition | `vim.lsp.buf.type_definition()` |
| `K` | Hover Documentation | `vim.lsp.buf.hover()` |
| `<C-S-k>` | Parameter Signature Help (Normal & Insert) | `vim.lsp.buf.signature_help()` |
| `<leader>ca` | Code Actions (Quick fixes, refactors) | `vim.lsp.buf.code_action()` |
| `<leader>rn` | Rename Symbol Across Project | `vim.lsp.buf.rename()` |
| `<leader>ld` | Show Line Diagnostics Float Window | `vim.diagnostic.open_float()` |
| `]d` / `[d` | Next / Previous Diagnostic Item | `vim.diagnostic.jump()` |
| `]e` / `[e` | Next / Previous Error Only | `vim.diagnostic.jump(severity=ERROR)` |
| `<leader>lh` | Toggle Inlay Hints (Types, Parameters) | `vim.lsp.inlay_hint.enable()` |
| `<leader>li` | View Incoming Calls (Call Hierarchy) | `vim.lsp.buf.incoming_calls()` |
| `<leader>lo` | View Outgoing Calls (Call Hierarchy) | `vim.lsp.buf.outgoing_calls()` |
| `<leader>ll` | Run Codelens Under Cursor | `vim.lsp.codelens.run()` |
| `<leader>lL` | Refresh Buffer Codelenses | `vim.lsp.codelens.refresh()` |

#### 5. Autocompletion & Snippets (Blink.cmp)
| Keybinding | Description | Action |
| :--- | :--- | :--- |
| `<Tab>` | Select Next / Snippet Forward / Indent | `blink.cmp.select_next` -> `snippet_forward` -> `fallback` |
| `<S-Tab>` | Select Previous / Snippet Backward | `blink.cmp.select_prev` -> `snippet_backward` -> `fallback` |
| `<CR>` | Accept Completion Item | `blink.cmp.accept` |
| `<C-space>` | Trigger Completion / Toggle Docs | `blink.cmp.show` / `show_documentation` |
| `<C-j>` / `<C-k>` | Select Next / Previous Item | `blink.cmp.select_next` / `select_prev` |
| `<C-b>` / `<C-f>` | Scroll Documentation Up / Down | `blink.cmp.scroll_documentation_up` / `down` |
| `<C-e>` | Hide Completion Menu | `blink.cmp.hide` |

#### 6. `<leader>c` — Code, Formatting & Parameter Swaps
| Keybinding | Description | Command / Implementation |
| :--- | :--- | :--- |
| `<leader>cf` | Format Buffer / Visual Selection | `conform.format({ lsp_format = "fallback" })` |
| `<leader>cl` | Lint Current Buffer (`:Lint`) | `nvim-lint.try_lint()` |
| `<leader>cx` | Swap with Next Parameter | Treesitter textobject swap |
| `<leader>cX` | Swap with Previous Parameter | Treesitter textobject swap |

#### 7. `<leader>r` — Rust (Rustaceanvim)
| Keybinding | Description | Command / Implementation |
| :--- | :--- | :--- |
| `<leader>rr` | Cargo Runnables Picker | `:RustLsp runnables` |
| `<leader>rt` | Cargo Testables Picker | `:RustLsp testables` |
| `<leader>rD` | Debuggables (Launch CodeLLDB on Target)| `:RustLsp debuggables` |
| `<leader>re` | Expand Macro Recursively | `:RustLsp expandMacro` |
| `<leader>rc` | Open Cargo.toml | `:RustLsp openCargo` |
| `<leader>rp` | Go to Parent Module | `:RustLsp parentModule` |
| `<leader>rd` | Render Diagnostics & Fixes | `:RustLsp renderDiagnostic` |
| `<leader>rm` | Rebuild Procedural Macros | `:RustLsp rebuildProcMacros` |
| `<leader>rk` | Move Item / Function Up | `:RustLsp moveItem up` |
| `<leader>rj` | Move Item / Function Down | `:RustLsp moveItem down` |
| `<leader>ra` | Rust-Specific Code Actions | `:RustLsp codeAction` |
| `<leader>rh` | Rust-Specific Hover Actions | `:RustLsp hover actions` |

#### 8. `<leader>G` — Go (Go.nvim)
| Keybinding | Description | Command / Implementation |
| :--- | :--- | :--- |
| `<leader>Gt` | Run Package Go Tests | `:GoTest` |
| `<leader>Gf` | Run Current Go Test Function | `:GoTestFunc` |
| `<leader>Gc` | Toggle Line Coverage Heatmap | `:GoCoverage` |
| `<leader>Ga` | Add Struct Tags (JSON, YAML, etc.) | `:GoAddTag` |
| `<leader>Gr` | Remove Struct Tags | `:GoRmTag` |
| `<leader>Gi` | Implement Interface Stubs | `:GoImpl` |
| `<leader>Ge` | Generate `if err != nil` Boilerplate | `:GoIfErr` |
| `<leader>Gd` | Start Delve Debugger | `dap.continue()` (nvim-dap) |
| `<leader>GD` | Stop Delve Debugger | `dap.terminate()` (nvim-dap) |
| `<leader>Gl` | Run golangci-lint | `:GoLint` |
| `<leader>Gv` | Run `go vet` | `:GoVet` |
| `<leader>Gg` | Run `go generate` | `:GoGenerate` |
| `<leader>Gm` | Run `go mod tidy` | `:GoModTidy` |

#### 9. `<leader>t` — Testing (Neotest TDD Suite)
| Keybinding | Description | Command / Implementation |
| :--- | :--- | :--- |
| `<leader>tt` | Run Nearest Test Case | `neotest.run.run()` |
| `<leader>tf` | Run All Tests in Current File | `neotest.run.run(vim.fn.expand("%"))` |
| `<leader>ta` | Run Entire Project Test Suite | `neotest.run.run(vim.fn.getcwd())` |
| `<leader>tw` | Toggle Watch Mode (rerun on save) | `neotest.watch.toggle()` |
| `<leader>td` | Debug Nearest Test (DAP strategy) | `neotest.run.run({ strategy = "dap" })` |
| `<leader>ts` | Toggle Test Summary Tree View | `neotest.summary.toggle()` |
| `<leader>to` | Open Floating Test Output | `neotest.output.open({ enter = true })` |
| `<leader>tO` | Toggle Test Output Panel | `neotest.output_panel.toggle()` |
| `<leader>tS` | Stop Running Test(s) | `neotest.run.stop()` |
| `]T` / `[T` | Jump to Next / Previous Failed Test | `neotest.jump.next/prev({ status = "failed" })` |

#### 10. `<leader>d` — Debugging (nvim-dap & DAP-UI)
| Keybinding | Description | Command / Implementation |
| :--- | :--- | :--- |
| `<leader>db` | Toggle Breakpoint on Line | `dap.toggle_breakpoint()` |
| `<leader>dB` | Set Conditional Breakpoint | `dap.set_breakpoint(prompt)` |
| `<leader>dc` | Continue / Launch Target | `dap.continue()` |
| `<leader>dC` | Run to Cursor | `dap.run_to_cursor()` |
| `<leader>di` | Step Into Instruction / Function | `dap.step_into()` |
| `<leader>do` | Step Over Instruction / Function | `dap.step_over()` |
| `<leader>dO` | Step Out of Current Stack Frame | `dap.step_out()` |
| `<leader>dp` | Pause Target Execution | `dap.pause()` |
| `<leader>dr` | Restart Debugging Session | `dap.restart()` |
| `<leader>dl` | Run Last Debug Configuration | `dap.run_last()` |
| `<leader>dt` | Terminate Debug Session | `dap.terminate()` |
| `<leader>du` | Toggle DAP-UI Layout | `dapui.toggle({})` |
| `<leader>de` | Evaluate Expression Under Cursor | `dapui.eval()` (Normal & Visual) |
| `<leader>dw` | Hover Variable Widget | `dap.ui.widgets.hover()` |

#### 11. `<leader>u` — UI, Theme & Feature Toggles
| Keybinding | Description | Command / Implementation |
| :--- | :--- | :--- |
| `<leader>ut` | Open Base46 NvChad Theme Selector | `:NvChadTheme` / `base46-themes.pick()` |
| `<leader>un` | Dismiss All Notifications | `noice.cmd("dismiss")` |
| `<leader>uh` | Toggle Hardtime Motion Discipline | `hardtime.toggle()` |
| `<leader>up` | Toggle Precognition Motion Hints | `precognition.toggle()` |

#### 12. `<leader>x` — Trouble & Diagnostics Management
| Keybinding | Description | Command / Implementation |
| :--- | :--- | :--- |
| `<leader>xx` | Toggle Workspace Diagnostics List | `:Trouble diagnostics toggle` |
| `<leader>xX` | Toggle Current Buffer Diagnostics | `:Trouble diagnostics toggle filter.buf=0` |
| `<leader>xs` | Toggle Document Symbols Tree | `:Trouble symbols toggle` |
| `<leader>xl` | Toggle LSP References & Definitions | `:Trouble lsp toggle` |
| `<leader>xL` | Toggle Location List | `:Trouble loclist toggle` |
| `<leader>xQ` | Toggle Quickfix List | `:Trouble qflist toggle` |

---

## 3. TDD Workflows for Systems Engineering

### C++: Google Test & CTest Test-Driven Development

Modern systems C++ demands fast, rigorous unit testing verifying memory safety, allocation bounds, and computational correctness.

#### 1. CMake & GTest Configuration Structure
```cmake
cmake_minimum_required(VERSION 3.25)
project(EngineSystemsCore LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

include(FetchContent)
FetchContent_Declare(
  googletest
  URL https://github.com/google/googletest/archive/refs/tags/v1.14.0.zip
)
FetchContent_MakeAvailable(googletest)

enable_testing()

add_executable(memory_pool_test tests/memory_pool_test.cpp src/memory_pool.cpp)
target_link_libraries(memory_pool_test PRIVATE GTest::gtest_main)

include(GoogleTest)
gtest_discover_tests(memory_pool_test)
```

#### 2. C++23 Google Test Implementation
```cpp
#include <gtest/gtest.h>
#include <span>
#include <memory_resource>

class FixedMemoryPoolTest : public ::testing::Test {
protected:
    void SetUp() override {
        buffer_.fill(0xAA);
    }
    std::array<std::byte, 1024> buffer_;
};

TEST_F(FixedMemoryPoolTest, AllocatesAlignedBlockCorrectly) {
    std::pmr::monotonic_buffer_resource pool(buffer_.data(), buffer_.size());
    void* ptr = pool.allocate(64, alignof(std::max_align_t));
    
    ASSERT_NE(ptr, nullptr);
    EXPECT_EQ(reinterpret_cast<std::uintptr_t>(ptr) % alignof(std::max_align_t), 0u);
}

TEST_F(FixedMemoryPoolTest, ThrowsOnPoolExhaustion) {
    std::pmr::monotonic_buffer_resource pool(buffer_.data(), 128);
    EXPECT_NO_THROW([[maybe_unused]] void* p1 = pool.allocate(120));
    EXPECT_THROW([[maybe_unused]] void* p2 = pool.allocate(64), std::bad_alloc);
}
```

#### 3. Execution & Debugging Workflow
1. Place cursor inside `TEST_F(FixedMemoryPoolTest, AllocatesAlignedBlockCorrectly)`.
2. Press `<leader>tt` to run this specific test. The Neotest floating window immediately indicates test status.
3. If an assertion fails, press `<leader>to` to inspect the exact failure line and memory diff.
4. Press `<leader>ts` to open the full test suite summary tree.
5. Launch CodeLLDB via `<leader>dc` or debug directly to halt at assertion failures.

---

### Rust: Cargo Testables, Workspace Filtering & Clippy Invariants

Rust systems code leverages zero-cost abstractions, RAII, and thread-safety guarantees validated through unit, integration, and doc tests.

#### 1. Idiomatic Test Module Architecture
```rust
// src/ring_buffer.rs
pub struct RingBuffer<T, const CAP: usize> {
    storage: [Option<T>; CAP],
    head: usize,
    tail: usize,
}

impl<T, const CAP: usize> RingBuffer<T, CAP> {
    pub const fn new() -> Self {
        Self { storage: [const { None }; CAP], head: 0, tail: 0 }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_ring_buffer_fifo_ordering() {
        let mut rb = RingBuffer::<u32, 4>::new();
        assert_eq!(rb.head, 0);
    }

    #[test]
    #[should_panic(expected = "Buffer overflow")]
    fn test_ring_buffer_overflow_panics() {
        // Validation of boundary guards
        panic!("Buffer overflow");
    }
}
```

#### 2. Cargo Testables & Workspace Filtering
- **Run Nearest Test**: With cursor inside `test_ring_buffer_fifo_ordering`, press `<leader>tt`.
- **Target Specific Crate**: In multi-crate workspaces:
  - Press `<leader>rt` to open the `RustLsp testables` interactive picker.
  - Filter by crate, binary, or test module.
- **Debug Rust Test**: Press `<leader>rD` (`RustLsp debuggables`) to launch CodeLLDB with synthetic data formatters active, automatically breaking on Rust panics.
- **Continuous Clippy Invariants**: Clippy runs asynchronously on every buffer save (`--no-deps`), reporting systems anti-patterns:
  - `clippy::undocumented_unsafe_blocks`
  - `clippy::transmute_ptr_to_ptr`
  - `clippy::needless_pass_by_value`

---

### Go: Table-Driven Tests, Subtests, Race Detection & Profiling

Go systems development utilizes table-driven test fixtures, concurrency race testing, and coverage visualization.

#### 1. Table-Driven Test with Subtests & Race Validation
```go
package buffer_test

import (
	"sync"
	"testing"
)

func TestConcurrentQueue(t *testing.T) {
	tests := []struct {
		name       string
		goroutines int
		opsPerGo   int
	}{
		{"LightContention", 4, 1000},
		{"HeavyContention", 64, 10000},
	}

	for _, tc := range tests {
		tc := tc // capture range variable
		t.Run(tc.name, func(t *testing.T) {
			t.Parallel()
			var wg sync.WaitGroup
			for i := 0; i < tc.goroutines; i++ {
				wg.Add(1)
				go func() {
					defer wg.Done()
					for j := 0; j < tc.opsPerGo; j++ {
						// Concurrent atomic operations
					}
				}()
			}
			wg.Wait()
		})
	}
}
```

#### 2. Go TDD Keymap Actions
- **Run Package Tests**: `<leader>Gt` (`:GoTest`) executes `go test ./...` in a non-blocking float terminal.
- **Run Single Function**: `<leader>Gf` (`:GoTestFunc`) runs the function enclosing the cursor.
- **Live Coverage Heatmap**: Press `<leader>Gc` (`:GoCoverage`) to toggle line-by-line coverage highlighting directly in the editor buffer (green = covered, red = uncovered).
- **Delve Test Debugging**: Press `<leader>Gd` to launch Delve via `dap.continue()` (configs in dap.lua include current file, package, and `mode = "test"` variants), stepping across goroutines and inspecting channel states.

---

### Zig: Simple Unit Tests & Canonical Formatting

Zig support is streamlined around the standard test runner and canonical formatting.

#### 1. Zig Test Execution
```zig
const std = @import("std");

test "ring buffer preserves FIFO order" {
    var buffer: [4]u32 = undefined;
    var tail: usize = 0;
    for (0..4) |i| {
        buffer[tail] = @intCast(i);
        tail = (tail + 1) % buffer.len;
    }
    try std.testing.expectEqual(3, buffer[3]);
}
```

**Workflow**: Zig testing has no Neotest adapter; run the standard test binary directly, e.g. `:!zig test %`
or open a terminal and run `zig test src/main.zig` after `zig build`. Debugging uses the shared CodeLLDB
configurations; formatting on save runs `zig fmt` through conform.nvim, producing canonical Zig style
per the official formatter.

---

## 4. Low-Level LLDB Systems Debugging Manual

A comprehensive operational manual for diagnosing memory corruptions, register states, disassembly, and compiler optimizations using CodeLLDB within Neovim.

---

### Memory Hex Dumps & Data Representation

The LLDB `memory read` command (aliased to `x`) inspects raw virtual memory at any pointer or register location.

#### 1. Command Syntax & Specifiers
```lldb
memory read --format <format> --size <size> --count <count> <address>
# Shorthand:
x/<count><format><size> <address_or_expression>
```

| Specifier Type | Character | Meaning | Systems Usage |
| :--- | :---: | :--- | :--- |
| **Size** | `b` | 1 Byte (8 bits) | Raw byte inspection, string buffers |
| | `h` | Halfword (2 Bytes, 16 bits) | 16-bit integer / UTF-16 characters |
| | `w` | Word (4 Bytes, 32 bits) | 32-bit integers, IPv4 addresses, flags |
| | `g` | Giant Word (8 Bytes, 64 bits) | Pointers, 64-bit integers, vtable addresses |
| **Format** | `x` | Hexadecimal | Bitmasks, pointers, raw hex |
| | `d` | Signed Decimal | Signed integers |
| | `u` | Unsigned Decimal | Counters, size fields |
| | `f` | Floating Point | `float` and `double` representations |
| | `c` | Character / ASCII | Char buffers, protocol headers |
| | `s` | String | Null-terminated C-strings |
| | `i` | Instruction | Disassembled machine instructions |

#### 2. Practical Memory Diagnostics

```lldb
# 1. Inspect 32 raw bytes of a buffer in hex:
(lldb) x/32xb buffer_ptr
0x7fffffffdc40: 0xaa 0xaa 0xaa 0xaa 0x55 0x55 0x55 0x55
0x7fffffffdc48: 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00
0x7fffffffdc50: 0xef 0xbe 0xad 0xde 0x01 0x00 0x00 0x00
0x7fffffffdc58: 0x40 0xdc 0xff 0xff 0xff 0x7f 0x00 0x00

# 2. Inspect 8 64-bit pointers (Giant Words) at Stack Pointer ($rsp):
(lldb) x/8xg $rsp
0x7fffffffdc00: 0x00007fffffffdc40 0x00000000004011e5
0x7fffffffdc10: 0x00007ffff7fa2000 0x0000000000000000
0x7fffffffdc20: 0x00007fffffffdc50 0x0000000000401290
0x7fffffffdc30: 0x00007ffff7df5083 0x00007fffffffdc40

# 3. Analyze Structure Padding & Alignment:
# Given struct { char a; int b; char c; long d; };
(lldb) x/16xb &my_struct
0x7fffffffdc40: 0x41 [0x00 0x00 0x00] 0x2a 0x00 0x00 0x00  <-- 'A', 3 padding bytes, int 42
0x7fffffffdc48: 0x42 [0x00 0x00 0x00 0x00 0x00 0x00 0x00]  <-- 'B', 7 padding bytes
0x7fffffffdc50: 0x00 0x10 0x00 0x00 0x00 0x00 0x00 0x00  <-- long 4096 (64-bit aligned)
```

- **Little-Endian Representation**: Note that `0xDEADBEEF` appears in byte order as `0xef 0xbe 0xad 0xde` on x86_64 and AArch64.
- **Buffer Overrun Detection**: Look for overwritten stack canaries or corrupted return addresses immediately following allocated stack arrays.

---

### CPU Register Inspection & Architectural Analysis

#### 1. Register Architecture Reference

```
  x86_64 Architecture                         AArch64 (ARM64) Architecture
┌────────────────────────────────────────┐  ┌────────────────────────────────────────┐
│ 64-bit GPRs:                           │  │ 64-bit GPRs:                           │
│ rax : Accumulator / Return value       │  │ x0-x7   : Function args / Return values│
│ rbx : Callee-saved Base register       │  │ x8      : Indirect result pointer      │
│ rcx : 4th argument / Loop counter      │  │ x9-x15  : Caller-saved temporaries     │
│ rdx : 3rd argument / I/O pointer       │  │ x16-x17 : Intra-procedure call scratch│
│ rsi : 2nd argument / Source index      │  │ x19-x28 : Callee-saved registers      │
│ rdi : 1st argument / Destination index │  │ x29 (FP): Frame pointer                │
│ r8  : 5th argument                     │  │ x30 (LR): Link Register (return addr)  │
│ r9  : 6th argument                     │  │ sp      : Stack Pointer                │
│ r10-r11: Caller-saved temporaries      │  │ pc      : Program Counter              │
│ r12-r15: Callee-saved registers        │  ├────────────────────────────────────────┤
│ rbp : Frame pointer                    │  │ Vector / SIMD (128-bit):               │
│ rsp : Stack pointer                    │  │ v0-v31  : 128-bit Neon vector registers│
│ rip : Instruction pointer              │  │ (q0-q31, d0-d31, s0-s31)               │
├────────────────────────────────────────┤  └────────────────────────────────────────┘
│ Vector / AVX-2 / AVX-512:              │
│ ymm0-ymm15 : 256-bit AVX registers     │
│ zmm0-zmm31 : 512-bit AVX-512 registers │
├────────────────────────────────────────┤
│ Flags (rflags):                        │
│ CF (Carry)   ZF (Zero)   SF (Sign)     │
│ OF (Overflow)IF (Interrupt)            │
└────────────────────────────────────────┘
```

#### 2. Register Commands in LLDB

```lldb
# 1. Read all General Purpose Registers:
(lldb) register read --all
(lldb) re r

# 2. Read specific registers:
(lldb) register read rax rsp rdi rsi rflags

# 3. Inspect AVX / SIMD Vector Registers (ymm0 as 8 packed 32-bit floats):
(lldb) register read ymm0 --format f32
ymm0 = {1.0, 2.5, 0.0, -1.2, 3.1415, 0.5, 10.0, 0.0}

# 4. Dereference Register Offsets (e.g., struct pointer in $rdi):
(lldb) p *(MyStruct*)($rdi)
(lldb) memory read -c 8 "$rsp + 16"

# 5. Inspect condition flags:
(lldb) p/x ($rflags)
(lldb) p ($rflags & (1 << 6)) != 0   # Check Zero Flag (ZF)
```

---

### Disassembly, Instruction Stepping & ABI Calling Conventions

#### 1. Disassembly Commands

```lldb
# Set Intel disassembly syntax (default systems preference):
(lldb) settings set target.x86-disassembly-flavor intel

# Disassemble current frame around Program Counter:
(lldb) disassemble --frame
(lldb) di -f

# Disassemble with mixed source lines (-m):
(lldb) disassemble -m -F intel --name process_network_packet

# Disassemble specific address range:
(lldb) disassemble --start-address 0x401120 --count 20
```

#### 2. Instruction Stepping Commands

| Action | LLDB Command | Shorthand | Neovim DAP Equivalent | Behavior |
| :--- | :--- | :---: | :---: | :--- |
| **Instruction Step Into** | `thread step-inst` | `si` / `stepi` | DAP Custom | Executes single machine instruction; steps into `call`. |
| **Instruction Step Over** | `thread step-inst-over`| `ni` / `nexti` | DAP Custom | Executes single machine instruction; skips over `call`. |
| **Source Step Into** | `thread step-in` | `s` | `<leader>di` | Steps into next high-level source statement. |
| **Source Step Over** | `thread step-over` | `n` | `<leader>do` | Steps over next high-level source statement. |
| **Source Step Out** | `thread step-out` | `finish` | `<leader>dO` | Runs until current function returns. |

#### 3. System V AMD64 ABI vs Windows x64 Calling Convention

```
System V AMD64 ABI (Linux, macOS, BSD):
  • Integer/Pointer Args: rdi (1st), rsi (2nd), rdx (3rd), rcx (4th), r8 (5th), r9 (6th)
  • Floating Point Args:  xmm0 through xmm7
  • Return Value:         rax (primary), rdx (secondary/128-bit)
  • Callee-Saved:         rbx, rsp, rbp, r12, r13, r14, r15
  • Stack Alignment:      16-byte boundary prior to `call`

Microsoft x64 ABI (Windows):
  • Integer/Pointer Args: rcx (1st), rdx (2nd), r8 (3rd), r9 (4th)
  • Floating Point Args:  xmm0 through xmm3 (slots shared with integer args)
  • Shadow Space:         Caller MUST allocate 32 bytes of shadow stack space above return address
  • Callee-Saved:         rbx, rbp, rdi, rsi, rsp, r12, r13, r14, r15, xmm6-xmm15
```

---

### Hardware Watchpoints & CPU Debug Registers

Hardware watchpoints leverage physical CPU debug registers (x86 `DR0`–`DR3` controlled via `DR7`; ARM `WVR`/`WCR`) to monitor memory addresses without code modification or execution slowdown.

```
Hardware Debug Register Allocation (x86_64):
┌──────────┬────────────────────────────────────────────────────────┐
│ Register │ Purpose                                                │
├──────────┼────────────────────────────────────────────────────────┤
│ DR0      │ Linear memory address for Breakpoint / Watchpoint #0   │
│ DR1      │ Linear memory address for Breakpoint / Watchpoint #1   │
│ DR2      │ Linear memory address for Breakpoint / Watchpoint #2   │
│ DR3      │ Linear memory address for Breakpoint / Watchpoint #3   │
│ DR6      │ Debug Status Register (indicates which DR tripped)     │
│ DR7      │ Debug Control Register (Read/Write, 1/2/4/8 byte size) │
└──────────┴────────────────────────────────────────────────────────┘
```

#### Practical Watchpoint Workflows

```lldb
# 1. Watch variable writes:
(lldb) watchpoint set variable global_sequence_id

# 2. Watch memory address writes for 8 bytes:
(lldb) watchpoint set expression -s 8 -- &ring_buffer->tail

# 3. Watch memory READS and WRITES (-w read_write):
(lldb) watchpoint set expression -w read_write -- &atomic_state_flag

# 4. List all active hardware watchpoints:
(lldb) watchpoint list

# 5. Set a condition on a watchpoint (stop only when value becomes corrupt):
(lldb) watchpoint modify -c "tail > 1024" 1

# 6. Delete watchpoint:
(lldb) watchpoint delete 1
```

- **Diagnosing Wild Pointers**: When an unknown thread or memory corruption overwrites a heap buffer header, set an expression watchpoint on the header address. The CPU immediately halts the offending instruction the instant it executes the write.

---

### Compiler Optimization Verification & Performance Analysis

Systems programming requires verifying that the compiler (`clang++`, `rustc`, `go`) generates expected vectorization and memory layouts under `-O2` / `-O3` / `--release`.

#### 1. SIMD Auto-Vectorization Verification
```cpp
// Target Loop
void add_floats(float* __restrict a, float* __restrict b, float* __restrict out, size_t n) {
    for (size_t i = 0; i < n; ++i) {
        out[i] = a[i] + b[i];
    }
}
```
In LLDB disassembly, verify the compiler vectorized the loop into AVX packed additions rather than scalar iterations:
```assembly
# Scalar Assembly (-O0 / Non-vectorized) [SLOW]:
movss   xmm0, dword ptr [rdi + 4*rax]
addss   xmm0, dword ptr [rsi + 4*rax]
movss   dword ptr [rdx + 4*rax], xmm0

# Vectorized Assembly (-O3 -march=native) [FAST]:
vmovups ymm0, ymmword ptr [rdi + rax]
vaddps  ymm0, ymm0, ymmword ptr [rsi + rax]
vmovups ymmword ptr [rdx + rax], ymm0
```

#### 2. Cache Line False Sharing & `alignas(64)`
When multiple threads update adjacent variables on the same 64-byte L1 cache line, CPU cores invalidate each other's cache lines (false sharing).

```cpp
// Anti-Pattern: False sharing on single cache line
struct ContendedCounters {
    std::atomic<uint64_t> thread_0_ops; // Offset 0
    std::atomic<uint64_t> thread_1_ops; // Offset 8  <-- Same 64B cache line!
};

// Systems Invariant: Aligned to separate cache lines
struct alignas(64) CacheAlignedCounter {
    std::atomic<uint64_t> ops;
};
```
Verify memory layout in LLDB:
```lldb
(lldb) p sizeof(CacheAlignedCounter)
(size_t) 64
(lldb) p alignof(CacheAlignedCounter)
(size_t) 64
```

---

## 5. Theme Management & Live Palette Sync Guide

### Base46 Standalone Engine Architecture

The editor features the complete **Base46** theme catalogue (60+ themes including `oxocarbon`, `onedark`, `gruvbox`, `tokyonight`, `catppuccin`, `nord`, `ayu_dark`) powered by `AvengeMedia/base46`.

This is completely decoupled from NvChad's monolithic UI modules:
- No NvChad statusline, tabline, or tree dependencies.
- Integrated directly into `nvim-treesitter`, `blink.cmp`, `nvim-dap`, `neotest`, `which-key`, and `telescope`.

---

### Theme Selection & Persistent State Engine

- **Interactive Switcher**: Press `<leader>ut` or execute `:NvChadTheme` to open the interactive theme picker.
- **Persistence Mechanism**: Theme selections are recorded by `lua/core/theme.lua` into:
  ```
  ~/.local/state/nvim/base46-theme
  ```
  Upon Neovim startup, the saved theme is restored automatically before UI rendering begins.

---

### Live Evil-Lualine Palette Recomputation

When a theme is selected, the system triggers live color synchronization without requiring an editor restart:

```
[ User selects theme via <leader>ut / :NvChadTheme ]
                        │
                        ▼
          [ base46.load(theme_name) ]
                        │
                        ▼
   [ vim.api.nvim_exec_autocmds("ColorScheme", {}) ]
                        │
                        ▼
      [ EvilineThemeRefresh Augroup Triggered ]
                        │
                        ▼
   [ lua/plugins/lualine.lua: base46_palette() ]
     - Queries base46.theme_tables for base_30 & base_16
     - Recomputes exact mode bar (▊) & diagnostic colors
     - Dispatches lualine.setup() with updated palette
```

---

## 6. Preserved Core Invariants

The following core components represent the foundational UI invariants of the workstation and are strictly preserved across all updates.

### Evil-Lualine Statusline
- **Path**: `lua/plugins/lualine.lua`
- **Architecture**: A minimalist, doom-emacs inspired statusline featuring:
  - Dynamic mode-colored visual anchor bar (`▊`) and editor icon (``).
  - Buffer file size, name, modified indicator (`●`), readonly flag (`󰌾`).
  - Real-time diagnostic summary counters (` `, ` `, ` `, `󰌵 `).
  - Active LSP client list dynamically aggregated from `vim.lsp.get_clients()`.
  - Encoding, fileformat, Git branch (` `), and Git diff counters (` `, `󰝤 `, ` `).

### Harpoon 2 File Pinning HUD
- **Path**: `lua/plugins/harpoon.lua`
- **Architecture**: The Primeagen's Harpoon 2 file switcher for high-frequency navigation between critical systems files:
  - `<leader>a`: Mark and append current buffer to Harpoon list.
  - `<C-e>`: Toggle floating Harpoon quick menu HUD.
  - `<leader>1` through `<leader>5`: Direct single-keystroke jump to pinned files.
  - `[h` / `]h`: Previous / next pinned file cycle.
  - Multi-workspace scoped persistence keyed on `vim.uv.cwd()`.

### Oil.nvim Filesystem Buffer Engine
- **Path**: `lua/plugins/oil.lua`
- **Architecture**: Stevearc's filesystem editor treating directories as editable Vim buffers:
  - `<leader>e` or `-`: Open parent directory in Oil.
  - Edit filenames, permissions, and directories directly with standard Vim motions (`cw`, `dd`, `p`, visual block edits).
  - Trash support (`delete_to_trash = true`) and LSP file method rename synchronization.

---

## 7. Installation, Tooling & Verification

### Prerequisites
- **Neovim 0.12+**
- **Git**, **Ripgrep (`rg`)**, **GNU Make**, **CMake 3.25+**
- **Clang / LLVM 17+** (including `clangd`, `clang-format`, `clang-tidy`, `lldb`)
- **Rust Toolchain** (`rustc`, `cargo`, `rust-analyzer`, `rustfmt`, `clippy`)
- **Go Toolchain 1.22+** (`go`, `gopls`, `dlv`, `golangci-lint`, `gofumpt`)
- **Python 3.12+** (`basedpyright`, `ruff`, `debugpy` — installed via Mason on first run)
- **Node.js** (`yamlls`, `dockerls`, `docker-compose` language service — installed via Mason)
- **Zig 0.13+** (`zig` binary drives `zig fmt` via conform.nvim; `zls` is installed by Mason)
- **Infra tooling**: YAML/Docker/HCL servers, `yamllint`, `hadolint`, `tflint`, `terraform` (all via Mason)
- **Nerd Font** (e.g., JetBrainsMono Nerd Font)

> Zig language support: `zls` is installed through Mason (server config with `build.zig.zon` root detection),
> the `zig` treesitter parser is auto-installed, and formatting runs `zig fmt --stdin` via conform.nvim.
> `commentstring`/commenting needs no plugin — Neovim 0.12 ships built-in treesitter-aware `gc`/`gcc` commenting.
> If Mason's `zls` build lags your Zig compiler (e.g. Zig 0.16 needs a 0.16-era `zls`), build `zls` from source
> for that Zig version and Mason's copy will simply be bypassed on PATH.
>
> Infrastructure languages: YAML is validated by `yamlls` (schemastore.org schemas) and linted with `yamllint`;
> Dockerfiles get `dockerls` with `hadolint`, and compose files (`*.docker-compose`) get the compose service;
> Terraform (`*.tf`, `*.tfvars`) serves via `terraform-ls` with `tflint` diagnostics and `terraform fmt`
> formatting through conform.nvim.

### Initial Launch & Health Check
```bash
# Clone configuration to standard path:
git clone <repo_url> ~/.config/nvim

# Launch Neovim (lazy.nvim bootstraps automatically):
nvim

# Verify environment health inside Neovim:
:checkhealth
:Mason
:ConformInfo
```

---
*Architected for Systems Engineers. High Throughput. Deterministic Latency. Zero Friction.*
