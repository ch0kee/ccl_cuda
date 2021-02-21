/* Connected-component labeling */
/*

1) load (obj) scene
2) voxelize
3) display voxel grid
4) connected-component labeling
*/
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include <iostream>
#include <memory>
#include <tuple>
#include <vector>

#define LOG(x) std::cout << __FUNCTION__ << ": "

class Grid {
public:
    void allocate(size_t x_size, size_t y_size, size_t z_size) {
        m_dimensions = std::make_tuple(x_size, y_size, z_size);

        m_cell_count = (x_size * y_size * z_size);
        size_t required_bytes = m_cell_count;// / 8;
        LOG(INFO) << "required bytes: " << required_bytes << std::endl;

        m_voxels.resize(required_bytes);
        std::fill(m_voxels.begin(), m_voxels.end(), false);
        std::fill(m_labels.begin(), m_labels.end(), 0); //0 means no label
    }

    auto x_size() const { return std::get<0>(m_dimensions); }
    auto y_size() const { return std::get<1>(m_dimensions); }
    auto z_size() const { return std::get<2>(m_dimensions); }

    bool is_black(size_t x, size_t y, size_t z) const {
        return m_voxels[index(x, y, z)];
    }

    bool is_white(size_t x, size_t y, size_t z) const {
        return !is_black(x, y, z);
    }

    void set_black(size_t x, size_t y, size_t z) {
        m_voxels[index(x, y, z)] = true;
    }

    void set_white(size_t x, size_t y, size_t z) {
        m_voxels[index(x, y, z)] = false;
    }

    size_t index(size_t x, size_t y, size_t z) const {
        return x + y * (x_size()) + z * (x_size() * y_size());
    }

    size_t cell_count() const {
        return m_cell_count;
    }

    size_t get_label(size_t x, size_t y, size_t z) const {
        return m_labels[index(x, y, z)];
    }

    void set_label(size_t l, size_t x, size_t y, size_t z) {
        m_labels[index(x, y, z)] = l;
    }

    bool has_label(size_t x, size_t y, size_t z) const {
        return m_labels[index(x, y, z)] != 0;
    }



private:


    std::vector<bool> m_voxels;
    std::vector<size_t> m_labels;
    
    std::tuple<size_t, size_t, size_t> m_dimensions;
    size_t m_cell_count{ 0 };


};

void ccl_cpu_two_phase(Grid& grid) {
    //Rosenfeld and Pfaltz 
    using label_t = size_t;


    std::vector<label_t> current_labels;
    std::vector<label_t> minimal_equivalent_label;

    //first phase
    for (size_t i = 0; i < grid.x_size(); ++i) {
        for (size_t j = 0; j < grid.y_size(); ++j) {
            for (size_t k = 0; k < grid.z_size(); ++k) {
                if (grid.is_black(i, j, k)) {
                    //if no neighbor has a label, assign a new label
                    


                }

            }
        }
    }

}

cudaError_t addWithCuda(int *c, const int *a, const int *b, unsigned int size);

__global__ void addKernel(int *c, const int *a, const int *b)
{
    int i = threadIdx.x;
    c[i] = a[i] + b[i];
}

int main()
{
    Grid g;
    g.allocate(100, 100, 100);
    label_cpu_two_phase(g);

    return 0;
}
