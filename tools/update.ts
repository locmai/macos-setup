#!/usr/bin/env bun
/**
 * Update nix flake inputs and auto-commit the result.
 * Usage: bun update.ts [--dry-run]
 */

import { spawnSync } from "child_process";
import { readFileSync } from "fs";
import { resolve } from "path";

const DRY_RUN = process.argv.includes("--dry-run");
const REPO_ROOT = resolve(import.meta.dir, "..");

function run(cmd: string, args: string[], opts: { cwd?: string } = {}): string {
  const result = spawnSync(cmd, args, {
    cwd: opts.cwd ?? REPO_ROOT,
    encoding: "utf8",
    stdio: ["inherit", "pipe", "pipe"],
  });
  if (result.status !== 0) {
    const err = result.stderr?.trim() || result.stdout?.trim() || "unknown error";
    throw new Error(`\`${cmd} ${args.join(" ")}\` failed (exit ${result.status}):\n${err}`);
  }
  return result.stdout?.trim() ?? "";
}

function getFlockHash(): string {
  const lockPath = resolve(REPO_ROOT, "flake.lock");
  return readFileSync(lockPath, "utf8");
}

function changedInputs(before: string, after: string): string[] {
  // Parse lastModified values per node to summarise what changed
  const parseNodes = (raw: string): Record<string, string> => {
    try {
      const lock = JSON.parse(raw);
      const nodes: Record<string, string> = {};
      for (const [name, node] of Object.entries(lock.nodes as Record<string, any>)) {
        if (node.locked?.lastModified) {
          nodes[name] = String(node.locked.lastModified);
        }
      }
      return nodes;
    } catch {
      return {};
    }
  };

  const prev = parseNodes(before);
  const curr = parseNodes(after);
  const changed: string[] = [];

  for (const name of new Set([...Object.keys(prev), ...Object.keys(curr)])) {
    if (prev[name] !== curr[name]) changed.push(name);
  }
  return changed;
}

async function main() {
  console.log(`[update] repo: ${REPO_ROOT}`);
  if (DRY_RUN) console.log("[update] dry-run mode — no changes will be committed");

  // 1. Capture current flake.lock
  const lockBefore = getFlockHash();

  // 2. Run nix flake update
  console.log("[update] running: nix flake update …");
  if (!DRY_RUN) {
    const { spawnSync: sp } = await import("child_process");
    const r = sp("nix", ["flake", "update"], {
      cwd: REPO_ROOT,
      stdio: "inherit",
      encoding: "utf8",
    });
    if (r.status !== 0) {
      throw new Error(`nix flake update failed with exit code ${r.status}`);
    }
  } else {
    console.log("[update] (skipped — dry-run)");
  }

  // 3. Check what changed
  const lockAfter = getFlockHash();
  if (!DRY_RUN && lockBefore === lockAfter) {
    console.log("[update] flake.lock unchanged — nothing to commit.");
    process.exit(0);
  }

  const inputs = changedInputs(lockBefore, lockAfter);
  const summary = inputs.length
    ? `update flake inputs: ${inputs.filter((n) => n !== "root").join(", ")}`
    : "update flake.lock";

  // 4. Stage and commit
  const today = new Date().toISOString().slice(0, 10);
  const message = `${summary} (${today})`;

  console.log(`[update] committing: "${message}"`);
  if (!DRY_RUN) {
    run("git", ["add", "flake.lock"]);
    run("git", ["commit", "-m", message]);
    console.log("[update] done.");
  } else {
    console.log("[update] (commit skipped — dry-run)");
    console.log(`[update] would commit: "${message}"`);
    const diff = run("git", ["diff", "flake.lock"]);
    if (diff) console.log("\n--- diff preview ---\n" + diff);
  }
}

main().catch((err) => {
  console.error("[update] error:", err.message);
  process.exit(1);
});
