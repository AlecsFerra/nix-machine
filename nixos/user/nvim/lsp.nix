{ pkgs, ... }:
{
  imports = [ ./extra-lang ];

  programs.nixvim = {
    
    keymaps = [
      # Diagnostic keymap
      {
        mode = "n";
        key = "[d";
        lua = true;
        action = /* lua */ "vim.diagnostic.goto_prev";
        options.desc = "Go to previous diagnostic message";
      }
      {
        mode = "n";
        key = "]d";
        lua = true;
        action = /* lua */ "vim.diagnostic.goto_next";
        options.desc = "Go to next diagnostic message";
      }
      {
        mode = "n";
        key = "<leader>e";
        lua = true;
        action = /* lua */ "vim.diagnostic.open_float";
        options.desc = "Open floating diagnostic message";
      }
      {
        mode = "n";
        key = "<leader>q";
        lua = true;
        action = /* lua */ "vim.diagnostic.setloclist";
        options.desc = "Open diagnostic list";
      }
    ];

    plugins.fidget.enable = true;
    plugins.nvim-autopairs.enable = true;

    # Servers
    plugins.lsp.servers = {
      clangd.enable = true;
      rust-analyzer = {
        enable = true;
        installRustc = false;
        installCargo = false;
      };
      pyright.enable = true;
      julials.enable = true;
    };


    plugins.lsp = {
      enable = true;

      onAttach = /* lua */ ''
        local nmap = function(keys, func, desc)
          if desc then
            desc = 'LSP: ' .. desc
          end

          vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
        end

        nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

        nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
        nmap(
          'gr', 
          require('telescope.builtin').lsp_references, 
          '[G]oto [R]eferences'
        )
        nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
        nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
        nmap(
          '<leader>ds',
          require('telescope.builtin').lsp_document_symbols, 
          '[D]ocument [S]ymbols'
        )
        nmap(
          '<leader>ws', 
          require('telescope.builtin').lsp_dynamic_workspace_symbols, 
          '[W]orkspace [S]ymbols'
        )

        -- See `:help K` for why this keymap
        nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
        nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
        
        nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        nmap(
          '<leader>wa', 
          vim.lsp.buf.add_workspace_folder, 
          '[W]orkspace [A]dd Folder'
        )
        nmap(
          '<leader>wr',
          vim.lsp.buf.remove_workspace_folder, 
          '[W]orkspace [R]emove Folder'
        )
        nmap(
          '<leader>wl', 
          function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end,
          '[W]orkspace [L]ist Folders'
        )

        -- Create a command `:Format` local to the LSP buffer
        vim.api.nvim_buf_create_user_command(
          bufnr, 
          'Format', 
          function(_)
            vim.lsp.buf.format()
          end, 
          { desc = 'Format current buffer with LSP' }
        )

        -- Code lenses refresh
        if client.supports_method("textDocument/codeLens") then
          nmap('<leader>cl', vim.lsp.codelens.run, '[C]ode [L]ense')
          vim.api.nvim_create_autocmd({ 'TextChanged', 'InsertLeave' }, {
            buffer = bufnr,
            callback = vim.lsp.codelens.refresh,
          })
          vim.api.nvim_exec_autocmds('User', { pattern = 'LspAttached' })
        end
      '';

      capabilities = /* lua */ ''
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = require('cmp_nvim_lsp')
                        .default_capabilities(capabilities)
      '';
    };

    plugins.luasnip.enable = true;
    plugins.nvim-cmp = {
      enable = true;
      mapping = {
        "<C-n>" = /* lua */ "cmp.mapping.select_next_item()";
        "<C-p>" = /* lua */ "cmp.mapping.select_prev_item()";
        "<C-d>" = /* lua */ "cmp.mapping.scroll_docs(-4)";
        "<C-f>" = /* lua */ "cmp.mapping.scroll_docs(4)";
        "<C-Space>" = /* lua */ "cmp.mapping.complete {}";
        "<CR>" = /* lua */ ''
          cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }
        '';
        "<Tab>" = /* lua */ ''
          cmp.mapping(
            function(fallback)
              local luasnip = require 'luasnip'
              if cmp.visible() then
                cmp.select_next_item()
              elseif luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
              else
                fallback()
              end
            end, 
            { 'i', 's' }
          )
        '';
        "<S-Tab>" = /* lua */ ''
          cmp.mapping(
            function(fallback)
              local luasnip = require 'luasnip'
              if cmp.visible() then
                cmp.select_prev_item()
              elseif luasnip.locally_jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end, 
            { 'i', 's' }
          )
        '';
      };

      snippet.expand = "luasnip";

      sources = [
        { name = "nvim_lsp"; }
        { name = "luasnip"; }
        { name = "path"; }
        { name = "buffer"; }
      ];
    };
  };
}
