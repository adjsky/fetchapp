import click
import scripts
import sys
@click.group()
def cli():
    pass

@click.command(short_help="solve exam problem")
@click.argument("number", type=int)
@click.option("-f", "--file", required=True, type=click.File(), help="file with data")
@click.option("-t", "--type", "type_", required=True, type=int, help="question type")
def solve(number, file, type_):
    """
        Solve exam problem

        NUMBER is a question number
    """
    if scripts.check_available(number):
        func = getattr(scripts, "solve_"+str(number))
        func(file, type_)
    else:
        sys.stdout = sys.stderr
        print("No algorithm available to solve this question.")
        sys.exit(1)

cli.add_command(solve)

if __name__ == "__main__":
    cli()