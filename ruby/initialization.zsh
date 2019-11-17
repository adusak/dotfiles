#!/bin/sh

add_lazy init_rbenv rbenv ruby rake bundle gem pod

init_rbenv() {
    eval "$(command rbenv init -)"
}