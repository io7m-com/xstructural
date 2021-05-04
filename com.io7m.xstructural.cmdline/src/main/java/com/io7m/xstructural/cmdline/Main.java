/*
 * Copyright © 2020 Mark Raynsford <code@io7m.com> http://io7m.com
 *
 * Permission to use, copy, modify, and/or distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
 * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR
 * IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

package com.io7m.xstructural.cmdline;

import com.beust.jcommander.JCommander;
import com.beust.jcommander.ParameterException;
import com.beust.jcommander.internal.Console;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

/**
 * Main command line entry point.
 */

public final class Main implements Runnable
{
  private static final Logger LOG = LoggerFactory.getLogger(Main.class);

  private final Map<String, XSCommandType> commands;
  private final JCommander commander;
  private final String[] args;
  private int exit_code;

  /**
   * The main program.
   *
   * @param inArgs The command-line arguments
   */

  public Main(
    final String[] inArgs)
  {
    this.args =
      Objects.requireNonNull(inArgs, "Command line arguments");

    final XSCommandRoot r = new XSCommandRoot();
    final var validate = new XSCommandValidate();
    final var xhtml = new XSCommandTransformXHTML();
    final var schema = new XSCommandSchema();

    this.commands = new HashMap<>(8);
    this.commands.put("validate", validate);
    this.commands.put("xhtml", xhtml);
    this.commands.put("schema", schema);

    this.commander = new JCommander(r);
    this.commander.setProgramName("xstructural");
    this.commander.addCommand("validate", validate);
    this.commander.addCommand("xhtml", xhtml);
    this.commander.addCommand("schema", schema);
  }

  /**
   * The main entry point.
   *
   * @param args Command line arguments
   */

  public static void main(final String[] args)
  {
    final Main cm = new Main(args);
    cm.run();
    System.exit(cm.exitCode());
  }

  /**
   * @return The program exit code
   */

  public int exitCode()
  {
    return this.exit_code;
  }

  @Override
  public void run()
  {
    try {
      this.commander.parse(this.args);

      final String cmd = this.commander.getParsedCommand();
      if (cmd == null) {
        final var console = new StringBuilderConsole();
        this.commander.setConsole(console);
        this.commander.usage();
        LOG.info("Arguments required.\n{}", console.builder.toString());
        this.exit_code = 1;
        return;
      }

      final XSCommandType command = this.commands.get(cmd);
      final XSCommandType.Status status = command.execute();
      this.exit_code = status.exitCode();
    } catch (final ParameterException e) {
      LOG.error("{}", e.getMessage());
      this.exit_code = 1;
    } catch (final Exception e) {
      LOG.error("{}", e.getMessage(), e);
      this.exit_code = 1;
    }
  }

  private static final class StringBuilderConsole implements Console
  {
    private final StringBuilder builder;

    StringBuilderConsole()
    {
      this.builder = new StringBuilder(128);
    }

    @Override
    public void print(final String s)
    {
      this.builder.append(s);
    }

    @Override
    public void println(final String s)
    {
      this.builder.append(s);
      this.builder.append('\n');
    }

    @Override
    public char[] readPassword(final boolean b)
    {
      return new char[0];
    }
  }
}
