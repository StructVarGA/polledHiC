#!/usr/bin/env python3

# Import modules here
import sys, os # for example


# Utility functions
def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)


def read_matrix_from_file(matrix_file):
    """read an HiC-Pro formated matrxi from file
        Parameters
        ----------
        filename : str
            path to the file to load. The file format should be as follows:
            i j counts (tab separated)

        Returns
        -------
        X : the count matrix
    """
    # A compléter
    pass


def merge_matrices(matrix_A, matrix):
    """
       A compléter
    """
    # A compléter
    pass

def write_matrix(matrix):
    """
       A compléter
    """
    # A compléter
    pass


def main(matrix_file_A, matrix_file_B):

    eprint("Merging the two matrices")
    matrix_a = read_matrix_from_file(matrix_A_file)
    matrix_b = read_matrix_from_file(matrix_B_file)

    matrix_c = merge_matrices(matrix_a, matrix_b)

    # Now write matrix to a file in HiC-Pro format


def parse_arguments():
    parser = argparse.ArgumentParser(description='Merging two HiC matrices sharing the same bins')
    parser.add_argument('-a', '--matrix_file_A',
                        required=True, help='A first matrix file')
    parser.add_argument('-b', '--matrix_file_B',
                        required=True, help='A second marix file')

    args = parser.parse_args()
    return args


if __name__ == '__main__':
    args = parse_arguments()
    main(args.matrix_A_file, args.matrix_B_file)
