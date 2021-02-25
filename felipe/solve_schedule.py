import sys
import math

def process(folder):
    # Load cars
    cars = []
    data_file = open("../data_out/" +  folder + "/cars.csv")
    count = 0
    for line in data_file.readlines():
        if count > 0:
            cars.append(line.rstrip().split('_'))
        count += 1

    # Load intersections
    count = 0
    data_file = open("../data_out/" +  folder + "/inter_out_streetcode.csv")
    intersections = dict()
    for line in data_file.readlines():
        if count > 0:
            line = line.rstrip().split(',')
            inter = line[0]
            line = line[1].split('_')
            intersections[inter] = dict(zip(line, [0] * len(line)))
        count += 1


     # Load streets - code -> in,out
    count = 0
    data_file = open("../data_out/" +  folder + "/streets.csv")
    streets = dict()
    for line in data_file.readlines():
        if count > 0:
            line = line.rstrip().split(',')
            streets[line[2]] = (line[0], line[1])
        count += 1

    # print(intersections)

    intersections_total = dict(zip(intersections.keys(), [0] * len(intersections.keys())))
    # Process the path and each car and add to the intersection end
    for path in cars:
        for st in path:
            pi = streets[st]
            # print(st, pi)
            pin = pi[0]
            pout = pi[1]
            intersections[pout][st] += 1
            intersections_total[pout] += 1

    # print(intersections)

    # Compute the frequency of each intersection
    for inter, streets in intersections.items():
        for st in streets:
            # print(inter, streets[st], (intersections_total[inter]))
            if intersections_total[inter] > 0:
                streets[st] = streets[st] / (intersections_total[inter])
            else:
                streets[st] = 0


    # print(intersections)

    return intersections


def main(argv):
    folder = argv[1]

    print("Processing problem ", folder)
    intersections = process(folder)

    print("Times computed")
   
    # Load streets - code
    count = 0
    data_file = open("../data_out/" +  folder + "/streets_code_and_names.csv")
    streetsnames = dict()
    for line in data_file.readlines():
        if count > 0:
            line = line.rstrip().split(',')
            streetsnames[line[1]] = line[0]
        count += 1

    # Write solution
    # Generate times
    total_time = argv[2]

    f = open(folder + "_solution.txt", "w")
    f.write(str(len(intersections.keys())) + "\n")
    for inter, streets in intersections.items():
        f.write(str(inter) + "\n" + str(len(streets)) + "\n")
        for st in streets:
            streets[st] = math.floor(streets[st] / float(total_time))
            f.write(str(streetsnames[st]) + " " + str(st)  +  "\n")
    f.close()


    

if __name__ == "__main__":
    main(sys.argv)