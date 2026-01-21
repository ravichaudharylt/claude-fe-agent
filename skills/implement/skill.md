# Implement Feature Skill (Master Orchestrator)

## Description
End-to-end feature implementation orchestrator. Works with any frontend project by auto-detecting tech stack, patterns, and conventions.

## Triggers
- User invokes `/implement <ticket-id>`
- User invokes `/implement` (manual mode)
- User invokes `/implement --resume`
- User invokes `/implement --status`

---

## Phase Overview

```
Phase 1: Gather Requirements    → /gather-requirements
Phase 2: Explore Codebase       → /explore-codebase
Phase 3: Decide Approach        → /decide-approach
Phase 4: Plan Implementation    → /plan-implementation
Phase 5: Setup Tests (TDD)      → /setup-tests
Phase 6: Execute Implementation → /execute-implementation
Phase 7: Validate & Finalize    → /validate-implementation
```

---

## CRITICAL RULES

### Rule 1: NEVER SKIP PHASES
```
⛔ FORBIDDEN: Skipping any phase
⛔ FORBIDDEN: Combining phases
⛔ FORBIDDEN: Starting Phase N+1 before Phase N complete
```

### Rule 2: Auto-Detect Everything
```
✅ Detect framework from package.json
✅ Detect test framework automatically
✅ Detect styling approach
✅ Detect component libraries
✅ Detect directory structure
✅ Adapt to project conventions
```

### Rule 3: Explicit Phase Transitions
Before moving to next phase:
1. Show: "Phase X complete. Output: [summary]"
2. Ask for explicit approval
3. Wait for confirmation
4. Log transition

---

## Workflow

### Initialization

1. **Parse arguments**
   - Check for `--resume`, `--status` flags
   - Extract ticket ID if provided

2. **Auto-detect project context**
   ```
   Read package.json:
   - framework: react|vue|nextjs|nuxt|svelte|angular
   - state_management: redux|zustand|mobx|vuex|pinia
   - test_framework: jest|vitest|mocha|cypress|playwright
   - styling: tailwind|styled-components|css-modules|scss
   - component_libraries: [detected]
   ```

3. **Check for existing workflow**
   - Read `.claude/workflow-state/current-workflow.json`
   - If exists, ask: Resume or Start fresh?

4. **Initialize workflow state**
   Create `.claude/workflow-state/current-workflow.json`:
   ```json
   {
     "workflow_id": "<uuid>",
     "ticket_id": "<ticket-id or 'manual'>",
     "started_at": "<timestamp>",
     "current_phase": 1,
     "project_context": {
       "framework": "<detected>",
       "test_framework": "<detected>",
       "styling": "<detected>"
     },
     "phase_history": [],
     "status": "in_progress"
   }
   ```

---

## Phase Execution

### For each phase (1-7):

1. **Announce phase**
   ```
   ═══════════════════════════════════════════════════
   PHASE [X]: [PHASE NAME]
   ═══════════════════════════════════════════════════
   ```

2. **Execute phase skill**
   - Pass context from previous phases
   - Use auto-detected project info

3. **Wait for completion**
   - Phase handles its own approval
   - Returns: approved, paused, failed, cancelled

4. **Log completion**
   Update `current-workflow.json`

5. **Handle result**
   - **approved:** Continue to next
   - **paused:** Save state, exit
   - **failed:** Ask user how to proceed
   - **cancelled:** Clean up, exit

---

## Phase Details

### Phase 1: Gather Requirements
- **Input:** Ticket ID or manual
- **Output:** `requirements.json`
- **Auto-detects:** Project context, ticket source (Jira/GitHub)

### Phase 2: Explore Codebase
- **Input:** `requirements.json`
- **Output:** `exploration.json`
- **Auto-detects:** Directory structure, patterns, architecture

### Phase 3: Decide Approach
- **Input:** `requirements.json`, `exploration.json`
- **Output:** `approach.json`
- **Presents:** 2-3 implementation approaches

### Phase 4: Plan Implementation
- **Input:** Previous outputs
- **Output:** `plan.json`
- **Creates:** Step-by-step implementation plan

### Phase 5: Setup Tests (TDD)
- **Input:** `requirements.json`, `plan.json`
- **Output:** `test-baseline.json`, test files
- **Auto-detects:** Test framework, test directory
- **CRITICAL:** Tests must FAIL before implementation

### Phase 6: Execute Implementation
- **Input:** `plan.json`, `test-baseline.json`
- **Output:** `execution-log.json`, modified code
- **Goal:** Make tests pass

### Phase 7: Validate & Finalize
- **Input:** All previous outputs
- **Output:** Validation report
- **Runs:** All tests, linter, type-check (if applicable)

---

## Completion

When all phases complete:

```
═══════════════════════════════════════════════════
✅ IMPLEMENTATION COMPLETE
═══════════════════════════════════════════════════

**Ticket:** [ticket-id]
**Project:** [project-name]
**Framework:** [detected]

### Phases Completed:
- [✅] All 7 phases

### Files Changed:
- [list]

### Next Steps:
- Review: `git diff`
- Test: `npm test` (or detected test command)
- Create PR: `gh pr create`
```

**Final prompt:**
```
question: "What would you like to do next?"
header: "Done"
options:
  - label: "Create PR"
    description: "Create pull request"
  - label: "Review changes"
    description: "Show change summary"
  - label: "Run more tests"
    description: "Additional validation"
  - label: "Done"
    description: "Handle manually"
```

---

## Status Check (`--status`)

```
═══════════════════════════════════════════════════
WORKFLOW STATUS
═══════════════════════════════════════════════════

Ticket: [id]
Project: [name]
Status: [In Progress/Paused]
Current Phase: [X]

Phase History:
  [✅] Phase 1: Gather Requirements
  [✅] Phase 2: Explore Codebase
  [🔄] Phase 3: Decide Approach (in progress)
  [⏳] Phase 4-7: Pending

Commands:
  /implement --resume    Continue
  /implement             Start fresh
```

---

## Auto-Detection Details

### Framework Detection
```javascript
// From package.json dependencies
{
  "react": "React",
  "next": "Next.js",
  "vue": "Vue",
  "nuxt": "Nuxt",
  "@angular/core": "Angular",
  "svelte": "Svelte"
}
```

### Test Framework Detection
```javascript
{
  "jest": "Jest",
  "vitest": "Vitest",
  "@playwright/test": "Playwright",
  "cypress": "Cypress",
  "mocha": "Mocha"
}
```

### Test Command Detection
1. Check package.json scripts for "test"
2. Default to detected framework's standard command
3. Ask user if unclear

### Base Branch Detection
1. Check for `main`, `master`, `develop`, `dev`, `stage`
2. Use git default branch
3. Ask user if multiple candidates

---

## Error Recovery

**Lost state:**
- Reconstruct from existing output files
- Confirm with user

**Corrupted files:**
- Validate JSON on load
- Offer to restart from last good state

**Phase failure:**
- Log details
- Offer: Retry, Go back, Pause, Abort

---

## Usage Examples

```bash
# With Jira ticket
/implement TTN-30874

# With GitHub issue
/implement #123

# Manual input
/implement

# Resume interrupted
/implement --resume

# Check status
/implement --status
```
