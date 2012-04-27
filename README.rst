VIM Settings
============

This is a cross-platform configuration that allows for system-specific
configuration without dirtying the repository.

It uses Tim Pope's pathogen_ VIM plugin to keep addons in their own
private directories.

Installation
------------

Clone the repository
~~~~~~~~~~~~~~~~~~~~

::

    git clone https://github.com/mmerickel/vim-settings.git ${HOME}/.vim
    git submodule init
    git submodule update

or ``C:\Users\USERNAME\_vimfiles`` on Windows.

Setup the vimrc
~~~~~~~~~~~~~~~

Copy the example vimrc file into VIM's runtime path::

    cp ${HOME}/vimrc.example ${HOME}/.vimrc

or ``C:\Users\USERNAME\_vimrc`` on Windows.

Some settings are platform-specific and are turned on/off via::

    let g:mysys = 'mac'

where valid options are arbitrary but currently ``mac``, ``dos`` and
``unix`` are used.

If the repository wasn't configured on VIM's runtime path, it can be placed
on the path by setting ``g:vim_local``::

    let g:vim_local = '~/.vim'

.. _pathogen: https://github.com/tpope/vim-pathogen
