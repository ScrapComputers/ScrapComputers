# obj_to_json.py
import json

def parse_obj(file_path):
    vertices = []
    edges = set()

    with open(file_path, 'r') as file:
        for line in file:
            parts = line.strip().split()
            
            if not parts:
                continue

            if parts[0] == 'v':
                vertex = tuple(map(float, parts[1:4]))
                vertices.append(vertex)

            elif parts[0] == 'f':
                face_indices = [int(part.split('/')[0]) - 1 for part in parts[1:]]
                num_vertices = len(face_indices)
                for i in range(num_vertices):
                    v1 = face_indices[i]
                    v2 = face_indices[(i + 1) % num_vertices]
                    edge = tuple(sorted((v1, v2)))
                    edges.add(edge)

    edges = list(edges)
    return vertices, edges


def write_json_file(vertices, edges, output_path):
    # Prepare data in dictionary form
    data = {
        "vertices": [{"x": v[0], "y": v[1], "z": v[2]} for v in vertices],
        "edges": [[edge[0] + 1, edge[1] + 1] for edge in edges]  # +1 for 1-based indexing
    }

    # Write JSON data to file
    with open(output_path, 'w') as file:
        json.dump(data, file, indent=4)


def main():
    input_path = 'input.obj'     # Path to the input .obj file
    output_path = 'output.json'  # Path for the generated JSON file

    vertices, edges = parse_obj(input_path)
    write_json_file(vertices, edges, output_path)
    print(f"JSON file generated: {output_path}")


if __name__ == '__main__':
    main()
