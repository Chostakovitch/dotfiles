#!/bin/sh

echo "%{F#77dd77}%{F#ddd} " $(uptime --pretty | sed 's/up //')
