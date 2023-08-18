{ pkgs, ... }:
let
  lua = call: 
    "<cmd>lua ${call}<cr>";
in
{
  programs.nixvim = {
   
   maps.normal = {
      # Diagnostic keymap
      "[d" = {
        action = lua "vim.diagnostic.goto_prev()";
        desc = "Go to previous diagnostic message";
      };
      "]d" = {
        action = lua "vim.diagnostic.goto_next()";
        desc = "Go to next diagnostic message";
      };
      "<leader>e" = {
        action = lua "vim.diagnostic.open_float()";
        desc = "Open floating diagnostic message";
      };
      "<leader>q" = {
        action = lua "vim.diagnostic.setloclist()";
        desc = "Open diagnostic list";
      };
    };

    plugins.fidget.enable = true;
    plugins.nvim-lightbulb.enable = true;
    plugins.nvim-autopairs.enable = true;

    plugins.lsp = {
      enable = true;

      onAttach = ''
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
      '';

      capabilities = ''
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
      '';
    };

    # Servers
    plugins.lsp.servers = {
      nixd.enable = true;
      clangd.enable = true;
      rust-analyzer.enable = true;
      pyright.enable = true;
      hls.enable = true;
    };

    plugins.luasnip.enable = true;
    plugins.nvim-cmp = {
      enable = true;
      mapping = {
        "<C-n>" = "cmp.mapping.select_next_item()";
        "<C-p>" = "cmp.mapping.select_prev_item()";
        "<C-d>" = "cmp.mapping.scroll_docs(-4)";
        "<C-f>" = "cmp.mapping.scroll_docs(4)";
        "<C-Space>" = "cmp.mapping.complete {}";
        "<CR>" = ''
          cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }
        '';
        "<Tab>" = ''
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
        "<S-Tab>" = ''
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
