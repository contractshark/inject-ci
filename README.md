# `inject-ci`

> CI Injection
> 
### Commands 

```bash
$GITHUB_SERVER_URL/$GITHUB_REPOSITORY/actions/runs/$GITHUB_RUN_ID



```

```yaml
   - name: Set selected color
        run: echo '::set-output name=SELECTED_COLOR::green'
        id: random-color-generator
      - name: Get color
        run: echo "The selected color is ${{ steps.random-color-generator.outputs.SELECTED_COLOR }}"

```

##### Setting an error message

::error file={name},line={line},col={col}::{message}

##### Setting a warning message

::warning file={name},line={line},col={col}::{message}

echo "::warning file=app.js,line=1,col=5::Missing semicolon"

#### Group log lines

```bash
echo "::group::My title"
echo "Inside group"
echo "::endgroup::"
```

##### runs.steps

Required The run steps that you plan to run in this action.
```bash
runs.steps[*].run
```

Required The command you want to run. This can be inline or a script in your action repository:

```yaml
runs:
  using: "composite"
  steps:
    - run: ${{ github.action_path }}/test/script.sh
      shell: bash
```
Alternatively, you can use $GITHUB_ACTION_PATH:

```yaml
runs:
  using: "composite"
  steps:
    - run: $GITHUB_ACTION_PATH/script.sh
      shell: bash
```

### License

EPL-2.0
